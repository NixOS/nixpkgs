set -e

. $stdenv/setup

cp $src .
bin=`basename $src`
chmod u+x $bin

alias more=cat
yes yes | ./$bin

mkdir $out
mv $dirname/* $out/

# remove crap in the root directory
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done
