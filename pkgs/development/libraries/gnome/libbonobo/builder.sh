#! /bin/sh -e

buildinputs="$pkgconfig $perl $ORBit2 $libxml2 $popt $yacc $flex"
. $stdenv/setup

tar xvfj $src
cd libbonobo-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$ORBit2 $popt" > $out/nix-support/propagated-build-inputs
