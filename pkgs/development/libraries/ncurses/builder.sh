buildinputs=""
. $stdenv/setup

tar xvfz $src
cd ncurses-*
./configure --prefix=$out --with-shared
make
make install
strip -S $out/lib/*.a
