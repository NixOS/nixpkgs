#! /bin/sh

buildinputs="$pkgconfig $libgnome $libgnomecanvas $libbonoboui $libglade"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd libgnomeui-* || exit 1
./configure --prefix=$out || exit 1
make || exit 1
make install || exit 1
strip -S $out/lib/*.a $out/lib/libglade/*/*.a || exit 1

echo "$libgnome $libgnomecanvas $libbonoboui" > $out/propagated-build-inputs || exit 1
