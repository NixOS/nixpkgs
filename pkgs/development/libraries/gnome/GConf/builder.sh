#! /bin/sh

buildinputs="$pkgconfig $perl $glib $gtk $libxml2 $ORBit2 $popt"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd GConf-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo "$ORBit2" > $out/propagated-build-inputs || exit 1
