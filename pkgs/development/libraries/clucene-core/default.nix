{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "clucene-core-0.9.16a";

  src = fetchurl {
    url = ftp://ftp.chg.ru/pub/sourceforge/c/cl/clucene/clucene-core-0.9.16a.tar.bz2;
    sha256 = "0hv7sp1lbicnj2984hiki8qwrvz5zwn1zhj6azhavgjklanhihjr";
  };

  meta = {
    description = "CLucene is a port of the very popular Java Lucene text search engine API. Core package.";
    homepage = http://clucene.sourceforge.net;
  };
  configureFlags = "--disable-static";
}
