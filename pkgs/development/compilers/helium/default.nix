{stdenv, fetchurl, ghc}:

assert ghc != null;

stdenv.mkDerivation {
  name = "helium-1.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cs.uu.nl/helium/distr/helium-1.2-src.tar.gz;
    md5 = "6ea1d6e4436e137d75f5354b4758f299";
  };
  inherit ghc;
}
