buildinputs="$pkgconfig $x11 $glib $xft"
. $stdenv/setup

tar xvfj $src
cd pango-*
./configure --prefix=$out
make
make install

mkdir $out/nix-support
echo "$xft $glib" > $out/nix-support/propagated-build-inputs
