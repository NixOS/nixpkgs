{stdenv, fetchurl, ghc}:

assert ghc != null;

stdenv.mkDerivation {
  name = "helium-1.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cs.uu.nl/helium/distr/helium-1.5-src.tar.gz;
    md5 = "b25fbee324a54059789eb1b4d62aa048";
  };
  inherit ghc;
}
