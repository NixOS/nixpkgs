#! /bin/sh

source $stdenv/setup || exit 1

cp $src $version.bin || exit 1
chmod u+x $version.bin || exit 1

alias more=cat

echo "Unpacking J2RE"
yes yes | ./$version.bin || exit 1

mkdir $out || exit 1

echo "Moving sources to the right location"
mv $version/* $out/ || exit 1

echo "Removing files at top level"
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done
rm -rf $out/docs
