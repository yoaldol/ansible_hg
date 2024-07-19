#!/bin/bash

# Variables
DIR="/etc/zabbix/zabbix_custom_scripts"
ANSWER=$DIR/answer.txt
TIME=$DIR/time.txt

### Ejecución de query de prueba contra la base.
# La respusta se guarda en archivo answer.txt.
# El tiempo de respuesta de la misma se guarda en time.txt 
/usr/bin/time -o $TIME -f "%e" su - proxysql -c 'mysql $USUPWD -e "SELECT * FROM stats_mysql_connection_pool order by srv_host, hostgroup"' > $ANSWER 

# Código de respuesta, verificar que es 0
#echo "RCode:3" #comando de prueba
echo "RCode:$?"

# Tiempo de respuesta, verificar que es menor que cierto umbral
#echo "RTime:1.5" #comando de prueba
echo "RTime:$(cat $TIME)"

# Cantidad de nodos online, verificar que es igual a 4
#echo "NodesOnline:2" #comando de prueba
echo "NodesOnline:$(grep -c "ONLINE" $ANSWER)"

# Borrar archivos auxiliares
rm -f $ANSWER
rm -f $TIME

