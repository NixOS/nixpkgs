buildinputs="$audiofile"
. $stdenv/setup

tar xvfj $src
cd esound-*
./configure --prefix=$out
make
make install
strip -S $out/lib/*.a

mkdir $out/nix-support
echo "$audiofile" > $out/nix-support/propagated-build-inputs
