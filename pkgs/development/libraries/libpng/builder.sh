#! /bin/sh

buildinputs="$zlib"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libpng-* || exit 1
make -f scripts/makefile.linux || exit 1
mkdir $out || exit 1
mkdir $out/bin || exit 1
mkdir $out/lib || exit 1
mkdir $out/include || exit 1
make -f scripts/makefile.linux install prefix=$out || exit 1
strip -S $out/lib/*.a || exit 1

echo "$zlib" > $out/propagated-build-inputs || exit 1
