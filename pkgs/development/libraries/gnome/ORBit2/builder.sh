buildinputs="$pkgconfig $glib $libIDL $popt"
. $stdenv/setup

tar xvfj $src
cd ORBit2-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$glib" > $out/nix-support/propagated-build-inputs
