#! /bin/sh -e

buildinputs="$zlib"
. $stdenv/setup

tar xvfz $src
cd rna-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$zlib" > $out/nix-support/propagated-build-inputs
