#!/bin/sh

. $stdenv/setup || exit 1
src=$filename.bin

cp $pathname $src || exit 1

actual=$(md5sum -b $src | cut -c1-32)
if test "$actual" != "$md5"; then
    echo "hash is $actual, expected $md5"
    exit 1
fi

chmod u+x $src || exit 1

alias more=cat

yes yes | ./$src || exit 1

mkdir $out || exit 1
mv $dirname/* $out/ || exit 1
