buildinputs="$pkgconfig $gtk $libxml2"
. $stdenv/setup

tar xvfj $src
cd libglade-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$gtk $libxml2" > $out/nix-support/propagated-build-inputs
