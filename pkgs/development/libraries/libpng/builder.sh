#! /bin/sh -e

buildInputs="$zlib"
. $stdenv/setup

tar xvfj $src
cd libpng-*
make -f scripts/makefile.linux
mkdir $out
mkdir $out/bin
mkdir $out/lib
mkdir $out/include
make -f scripts/makefile.linux install prefix=$out
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$zlib" > $out/nix-support/propagated-build-inputs
