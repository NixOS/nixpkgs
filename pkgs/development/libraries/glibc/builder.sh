#! /bin/sh

# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1
. $stdenv/setup

tar xvfj $glibcSrc
(cd glibc-* && tar xvfj $linuxthreadsSrc)

(cd glibc-* && patch -p1 < $vaargsPatch)

mkdir build
cd build
LDFLAGS=-Wl,-S ../glibc-*/configure --prefix=$out --enable-add-ons --disable-profile

make
make install
#make localedata/install-locales
strip -S $out/lib/*.a $out/lib/*.so $out/lib/gconv/*.so || true
strip -s $out/bin/* $out/sbin/* $out/libexec/* || true

ln -sf /etc/ld.so.cache $out/etc/ld.so.cache

(cd $out/include && ln -s $kernelHeaders/include/* .)

exit 0
