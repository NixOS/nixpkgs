#! /bin/sh

buildinputs="$x11 $glib"
. $stdenv/setup

tar xvfz $src
cd gtk+-*
./configure --prefix=$out
make
make install

mkdir $out/nix-support
echo "$x11 $glib" > $out/nix-support/propagated-build-inputs
