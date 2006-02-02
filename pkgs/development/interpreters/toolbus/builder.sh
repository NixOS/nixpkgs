source $stdenv/setup

PATH=$aterm/bin:$atermjava/bin:$toolbuslib/bin:$yacc/bin:$flex/bin:$PATH

tar xvfz $src
cd toolbus-*
./configure --prefix=$out
make
make install
