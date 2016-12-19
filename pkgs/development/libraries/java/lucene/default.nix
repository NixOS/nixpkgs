{stdenv, fetchurl} :

stdenv.mkDerivation {
  name = "lucene-1.4.1";
  builder = ./builder.sh;

  src = fetchurl {
    url = http://cvs.apache.org/dist/jakarta/lucene/v1.4.1/lucene-1.4.1.tar.gz;
    md5 = "656a6f40f5b8f7d2e19453436848bfe8";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
