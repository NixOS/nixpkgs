#! /bin/sh -e

buildinputs="$pkgconfig $perl $libxml2 $libglade $libgnome \
  $libgnomecanvas"
. $stdenv/setup

tar xvfj $src
cd libbonoboui-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$libxml2 $libgnome $libgnomecanvas" > $out/nix-support/propagated-build-inputs
