#! /bin/sh

buildinputs="$pkgconfig $perl $libxml2 $libglade $libgnome \
  $libgnomecanvas"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libbonoboui-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo "$libxml2 $libgnome $libgnomecanvas" > $out/propagated-build-inputs || exit 1
