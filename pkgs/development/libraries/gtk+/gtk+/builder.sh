#! /bin/sh -e

buildinputs="$pkgconfig $x11 $glib $atk $pango $perl $libtiff $libjpeg $libpng"
. $stdenv/setup

tar xvfj $src
cd gtk+-*
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib
make
make install

mkdir $out/nix-support
echo "$x11 $glib $atk $pango" > $out/nix-support/propagated-build-inputs
