#! /bin/sh -e

buildinputs="$pkgconfig $perl $glib $gtk $libxml2 $ORBit2 $popt"
. $stdenv/setup

tar xvfj $src
cd GConf-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$ORBit2" > $out/nix-support/propagated-build-inputs
