#! /bin/sh

. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd bzip2-* || exit 1
make || exit 1
make install PREFIX=$out || exit 1
