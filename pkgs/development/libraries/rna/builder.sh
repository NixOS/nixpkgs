#! /bin/sh -e

buildinputs="$zlib"
. $stdenv/setup

export NIX_STRIP_DEBUG=
export NIX_CFLAGS_COMPILE="-g $NIX_CFLAGS_COMPILE"

tar xvfz $src
cd rna-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$zlib" > $out/nix-support/propagated-build-inputs
