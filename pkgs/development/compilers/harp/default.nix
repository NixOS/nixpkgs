{stdenv, fetchurl, unzip, ghc, happy}:

stdenv.mkDerivation {
  name = "harp-0.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.dtek.chalmers.se/~d00nibro/harp/harp-0.1-src.zip;
    md5 = "8fc8552b7c05b5828b2e1b07f8c1f063";
  };
  buildInputs = [unzip ghc happy];
}
