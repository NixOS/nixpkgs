{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "jikes-1.18";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://www-126.ibm.com/pub/jikes/1.18/jikes-1.18.tar.bz2;
    md5 = "74bbcfd31aa2d7df4b86c5fe2db315cc";
  };
}
