buildinputs="$pkgconfig $gtk $libart $libglade"
. $stdenv/setup

tar xvfj $src
cd libgnomecanvas-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$gtk $libart" > $out/nix-support/propagated-build-inputs
