#! /bin/sh

buildinputs=""
if test -n "$zlibSupport"; then
  buildinputs="$zlib $buildinputs"
fi
. $stdenv/setup

tar xvfj $src
cd Python-*
./configure --prefix=$out

make
make install

