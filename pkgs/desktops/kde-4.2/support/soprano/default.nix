{stdenv, fetchurl, cmake, qt4, jdk, cluceneCore, redland}:

stdenv.mkDerivation {
  name = "soprano-2.2.3";
  src = fetchurl {
    url = mirror://sourceforge/soprano/soprano-2.2.3.tar.bz2;
    md5 = "22c992a252144ae0a3a964ba2f6f1933";
  };
  JAVA_HOME=jdk;
  buildInputs = [ cmake qt4 jdk cluceneCore redland ];
}
