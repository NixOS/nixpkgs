#! /bin/sh

buildinputs="$zlib $libjpeg"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd tiff-* || exit 1
./configure --prefix=$out --with-DIR_MAN=$out/man \
 --with-ZIP --with-JPEG \
 --with-DIRS_LIBINC="$zlib/include $libjpeg/include" || exit 1
make || exit 1
mkdir $out || exit 1
make install || exit 1
strip -S $out/lib/*.a || exit 1

echo "$zlib $libjpeg" > $out/propagated-build-inputs || exit 1
