#! /bin/sh

# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1
buildinputs="$patch"
. $stdenv/setup

tar xvfj $glibcSrc
(cd glibc-* && tar xvfj $linuxthreadsSrc) || false

(cd glibc-* && patch -p1 < $vaargsPatch) || false

mkdir build
cd build
../glibc-*/configure --prefix=$out --enable-add-ons --disable-profile

make
make install
make localedata/install-locales
strip -S $out/lib/*.a $out/lib/*.so $out/lib/gconv/*.so || true
strip -s $out/bin/* $out/sbin/* $out/libexec/* || true

rm $out/etc/ld.so.cache

(cd $out/include && ln -s $kernelHeaders/include/* .) || false

exit 0
