{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "expat-1.95.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/expat/expat-1.95.7.tar.gz;
    md5 = "2ff59c2a5cbdd21a285c5f343e214fa9";
  };
}
