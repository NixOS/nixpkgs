#! /bin/sh -e

set -x

buildinputs="$pkgconfig $fontconfig $x11"
. $stdenv/setup

tar xvfz $src
cd xft-*
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib
make
make install

mkdir $out/nix-support
echo "$fontconfig" > $out/nix-support/propagated-build-inputs
