#! /bin/sh

buildinputs="$pkgconfig $x11 $glib $xft"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd pango-* || exit 1
./configure --prefix=$out --x-includes=$x11/include --x-libraries=$x11/lib || exit 1
make || exit 1
make install || exit 1

echo "$xft" > $out/propagated-build-inputs || exit 1
