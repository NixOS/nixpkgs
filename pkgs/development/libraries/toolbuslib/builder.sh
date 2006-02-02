source $stdenv/setup

PATH=$aterm/bin:$PATH
set
tar xvfz $src
cd toolbuslib-*
./configure --prefix=$out
make
make install
