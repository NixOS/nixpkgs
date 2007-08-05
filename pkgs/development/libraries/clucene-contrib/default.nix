{ stdenv, fetchurl, cluceneCore}:

stdenv.mkDerivation {
  name = "clucene-contrib-0.9.16a";

  src = fetchurl {
    url = ftp://ftp.chg.ru/pub/sourceforge/c/cl/clucene/clucene-contrib-0.9.16a.tar.bz2;
    sha256 = "1apk867pggxsflhgvsnhcmy5vz2cvc1b914g4inkcj6s5vn1a1jx";
  };
  inherit cluceneCore;
  buildInputs=[cluceneCore];
  configureFlags = "--disable-static --with-clucene=${cluceneCore}";

  meta = {
    description = "CLucene is a port of the very popular Java Lucene text search engine API. Contrib package.";
    homepage = http://clucene.sourceforge.net;
  };
}
