#! /bin/sh

buildinputs="$aterm $sdf $make $automake $autoconf $libtool $which"
. $stdenv/setup || exit 1

echo "pwd = `pwd`"
echo "PATH = $PATH"

cp -r $src strategoxt || exit 1
chmod -R +w strategoxt
cd strategoxt || exit 1
./bootstrap || exit 1
./configure --prefix=$out --with-aterm=$aterm --with-sdf=$sdf || exit 1
make install || exit 1
