{stdenv, fetchurl, cmake, qt4, jdk, cluceneCore, redland}:

stdenv.mkDerivation {
  name = "soprano-2.2.1";
  src = fetchurl {
    url = mirror://sourceforge/soprano/soprano-2.2.1.tar.bz2;
    md5 = "69688a71273e1e9389fc60e3085c695f";
  };
  JAVA_HOME=jdk;
  buildInputs = [ cmake qt4 jdk cluceneCore redland ];
}
