#! /bin/sh -e

buildinputs="$pkgconfig $perl $glib $gnomevfs $libbonobo $GConf \
  $popt $zlib"
. $stdenv/setup

tar xvfj $src
cd libgnome-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$glib $gnomevfs $libbonobo $GConf" > $out/nix-support/propagated-build-inputs
