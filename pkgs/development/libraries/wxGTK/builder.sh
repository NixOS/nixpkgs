#! /bin/sh -e

buildinputs="$pkgconfig $gtk $libtiff $libjpeg $libpng $zlib"
. $stdenv/setup

extraflags=
if test -z "$compat22"; then
  extraflags="--disable-compat22 $extraflags"
fi

tar xvfj $src
cd wxGTK-*
./configure --prefix=$out --enable-gtk2 $extraflags
make
make install
