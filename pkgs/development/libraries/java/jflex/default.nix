{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "jflex-1.4";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://jflex.de/jflex-1.4.tar.gz;
    md5 = "120cedc76b278a476682edfa6828841f";
  };
}
