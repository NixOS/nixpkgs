{stdenv, fetchurl, ghc}:

stdenv.mkDerivation {
  name = "uulib-0.9.2";
  src = fetchurl {
    url = http://abaris.zoo.cs.uu.nl:8080/wiki/pub/HUT/Download/uulib-0.9.2-src.tar.gz;
    md5 = "0cc9acc6a268e2bc5c8a954e67406e2d";
  };
  builder = ./builder.sh;
  inherit ghc;
}
