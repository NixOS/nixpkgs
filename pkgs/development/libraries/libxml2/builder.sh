buildinputs="$zlib"
. $stdenv/setup

tar xvfj $src
cd libxml2-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$zlib" > $out/nix-support/propagated-build-inputs
