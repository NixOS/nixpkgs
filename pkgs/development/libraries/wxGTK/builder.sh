#! /bin/sh

buildinputs="$pkgconfig $gtk $libtiff $libjpeg $libpng $zlib"
. $stdenv/setup || exit 1

tar xvfj $src || exit 1
cd wxGTK-* || exit 1
./configure --prefix=$out --enable-gtk2 \
 --disable-compat22 \
 || exit 1
make || exit 1
make install || exit 1
