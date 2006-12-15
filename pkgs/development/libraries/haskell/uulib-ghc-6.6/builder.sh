source $stdenv/setup


tar xzf "$src" &&
cd uulib-* &&


autoconf &&
./configure --prefix=$out &&


ghc --make Setup.hs -o setup -package Cabal &&
./setup configure --prefix=$out --with-hc-pkg=ghc-pkg &&


./setup build &&
./setup install &&
./setup register --gen-script &&

mkdir -p $out/nix-support/ &&
cp register.sh $out/nix-support/register-ghclib.sh
