{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jikes-1.21";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://www-126.ibm.com/pub/jikes/1.21/jikes-1.21.tar.bz2;
    md5 = "4e45eeab4c75918174e16ea2b695d812";
  };
}
