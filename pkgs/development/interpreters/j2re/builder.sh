#!/bin/sh

. $stdenv/setup || exit 1
version=j2re1.4.2_03

cp $src $version.bin || exit 1
chmod u+x $version.bin || exit 1

alias more=cat

yes yes | ./$version.bin || exit 1

mkdir $out || exit 1
mv $version/* $out/ || exit 1
