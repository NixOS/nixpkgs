set -x

. $stdenv/setup

tar xvfz $src
cd readline-*
./configure --prefix=$out --with-curses
make
make install
#strip -S $out/lib/*/*.a
