#! /bin/sh -e

buildinputs="$pkgconfig $x11 $glib $xft"
. $stdenv/setup

tar xvfj $src
cd pango-*
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib
make
make install

mkdir $out/nix-support
echo "$xft $glib" > $out/nix-support/propagated-build-inputs
