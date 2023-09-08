#!/bin/sh

# Freebsd Brasil - Anderson Aguiar
# Modificacoes
# Mod - Data - Rensponsavel
#
# Configuracoes CRONTAB
# */30 * * * * root sh /root/blackhole.sh > /var/log/blackhole.log
#
#Verificar rotas inseridas com Script
#netstat -rn | grep UGSB
#
#Remover rotas inseridas pelo Script
#route delete
#########################

#Debug
#set -xv

export PATH="/bin:/usr/bin:/usr/local/sbin:/sbin:/usr/bin:/usr/local/sbin"

arquivo="/mnt/asustor/ipblock.deny"
arquivo2="/mnt/asustor/ipblock.allow"
logdir="/var/log/blackhole"
date=`date "+%Y-%m-%d"`
now=`date "+%Y/%m/%d - %H:%M"`
savedays="7"

echo ${now} - Executando Rotas: >> ${logdir}/${date}.log
cat $arquivo |egrep -v "139.59." | awk -F ";" '{print "route add " $1 "/32 127.0.01 -blackhole"}'|sh >> ${logdir}/${date}.log
echo ${now} - Finalizada Execucao de Rotas >> ${logdir}/${date}.log
echo >> ${logdir}/${date}.log


echo ${now} - Removendo Rotas: >> ${logdir}/${date}.log
cat $arquivo2 | awk -F ";" '{print "route delete " $1 "/32 127.0.01 -blackhole"}'|sh >> ${logdir}/${date}.log
echo ${now} - Finalizada Remocao de Rotas >> ${logdir}/${date}.log
echo >> ${logdir}/${date}.log

echo ${now} - Rotacionando logs: >> ${logdir}/${date}.log
find ${logdir}/ -name '*.log' -a -mtime +${savedays} -print -delete >> ${logdir}/${date}.log
echo >> ${logdir}/${date}.log
