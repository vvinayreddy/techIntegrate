#!/bin/bash
hn=`hostname`
queueDepth=( 2, 4, 6, 8, 16, 32, 64, 128)
numJobs=( 2, 4, 6, 8, 16)
fileNames=/dev/sdb:/dev/sdc
if [ -z "$1" ]
then
echo "please enter the blocksize for the test"
elif [ -z "$2" ]
then
echo "please enter the runtime for the test"
else
for i in "${queueDepth[@]}"
do
for j in "${numJobs[@]}"
do
echo Running $i QD with $j JOBS with bs $1 and 100RR
# test 4QD, 2 JOBS and 100 Random read 
sar -u -r -b -d -n DEV 5 1000 >> sar_$1_100RR_"$i"QD_"$j"Jobs_$hn.log &

iostat -x 5 1000 >> iostat_$1_100RR_"$i"QD_"$j"Jobs_$hn.log &

top -b -d 5 >> top_$1_100RR_"$i"QD_"$j"Jobs_$hn.log &

/usr/bin/fio --name=RandomReadTest --rw=randread --rwmixwrite=0 --bs=$1 --invalidate=1 --direct=1 --filename=$fileNames  --group_reporting --time_based --runtime=$2 --ioengine=libaio --numjobs=$j --iodepth=$i --norandommap --randrepeat=0 --exitall --output-format=json --output=fiotest_$1_100RR_"$i"QD_"$j"Jobs_$hn.json
pkill top 
pkill sar
pkill iostat
echo Running $i QD with $j JOBS with bs $1 and 70R30W
# test 4QD, 2 JOBS and 70% Read and 30% write

sar -u -r -b -d -n DEV 5 1000 >> sar_$1_70R30W_"$i"QD_"$j"Jobs_$hn.log &

iostat -x 5 1000 >> iostat_$1_70R30W_"$i"QD_"$j"Jobs_$hn.log &

top -b -d 5 >> top_$1_70R30W_"$i"QD_"$j"Jobs_$hn.log &

/usr/bin/fio --name=RandomReadWriteTest --rw=randrw --rwmixwrite=30 --bs=$1 --invalidate=1 --direct=1 --filename=$fileNames  --group_reporting --time_based --runtime=$2 --ioengine=libaio --numjobs=$j --iodepth=$i --norandommap --randrepeat=0 --exitall --output-format=json --output=fiotest_$1_70R30W_"$i"QD_"$j"Jobs_$hn.json
pkill top 
pkill sar
pkill iostat
echo Running $i QD with $j JOBS with bs $1 and 90R10W
# test 4QD, 2 JOBS and 90% Read and 10%writes

sar -u -r -b -d -n DEV 5 1000 >> sar_$1_90R10W_"$i"QD_"$j"Jobs_$hn.log &

iostat -x 5 1000 >> iostat_$1_90R10W_"$i"QD_"$j"Jobs_$hn.log &

top -b -d 5 >> top_$1_90R10W_"$i"QD_"$j"Jobs_$hn.log &

this ramraj testing hello

/usr/bin/fio --name=RandomReadWriteTest --rw=randrw --rwmixwrite=10 --bs=$1 --invalidate=1 --direct=1 --filename=$fileNames  --group_reporting --time_based --runtime=$2 --ioengine=libaio --numjobs=$j --iodepth=$i --norandommap --randrepeat=0 --exitall --output-format=json --output=fiotest_$1_90R10W_"$i"QD_"$j"Jobs_$hn.json
pkill top 
pkill sar
pkill iostat
echo Running $i QD with $j JOBS with bs $1 and 100RW
# test 4QD, 2 Jobs and 100% Randon write

sar -u -r -b -d -n DEV 5 1000 >> sar_$1_100RW_"$i"QD_"$j"Jobs_$hn.log &

iostat -x 5 1000 >> iostat_$1_100RW_"$i"QD_"$j"Jobs_$hn.log &

top -b -d 5 >> top_$1_100RW_"$i"QD_"$j"Jobs_$hn.log &

/usr/bin/fio --name=RandomWriteTest --rw=randwrite --rwmixread=0 --bs=$1 --invalidate=1 --direct=1 --filename=$fileNames  --group_reporting --time_based --runtime=$2 --ioengine=libaio --numjobs=$j --iodepth=$i --norandommap --randrepeat=0 --exitall --output-format=json --output=fiotest_$1_100RW_"$i"QD_"$j"Jobs_$hn.json
pkill top 
pkill sar
pkill iostat
done;
done;
fi