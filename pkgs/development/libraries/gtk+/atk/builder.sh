buildinputs="$pkgconfig $perl $glib"
. $stdenv/setup

tar xvfj $src
cd atk-*
./configure --prefix=$out
make
make install

mkdir $out/nix-support
echo "$glib" > $out/nix-support/propagated-build-inputs
