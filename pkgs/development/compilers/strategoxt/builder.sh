#! /bin/sh

buildinputs="$aterm $sdf"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd $dir* || exit 1
./configure --prefix=$out --with-aterm=$aterm --with-sdf=$sdf || exit 1
make || exit 1
make install || exit 1
