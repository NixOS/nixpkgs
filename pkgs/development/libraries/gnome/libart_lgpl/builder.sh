#! /bin/sh

buildinputs=""
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libart_lgpl-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1
