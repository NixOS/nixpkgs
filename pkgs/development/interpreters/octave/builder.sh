set -x

. $stdenv/setup

g77orig=$(cat $g77/nix-support/orig-gcc)
export NIX_LDFLAGS="-rpath $g77orig/lib $NIX_LDFLAGS"

export NIX_STRIP_DEBUG=
export NIX_CFLAGS_COMPILE="-g $NIX_CFLAGS_COMPILE"

tar xvfz $src
cd octave-*
./autogen.sh
./configure --prefix=$out --enable-readline
make
make install
#strip -S $out/lib/*/*.a
