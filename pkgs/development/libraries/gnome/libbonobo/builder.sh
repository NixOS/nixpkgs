#! /bin/sh

buildinputs="$pkgconfig $perl $ORBit2 $libxml2 $popt $yacc $flex"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libbonobo-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo "$ORBit2 $popt" > $out/propagated-build-inputs || exit 1
