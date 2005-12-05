source $stdenv/setup || exit 1

set -e

tar jxvf $src
cd clisp-*
./configure builddir --prefix=$out
cd builddir
./makemake --with-dynamic-ffi --prefix=$out > Makefile
make config.lisp
make
make install
