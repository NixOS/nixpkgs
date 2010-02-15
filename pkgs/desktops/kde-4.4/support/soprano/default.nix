{stdenv, fetchurl, lib, cmake, qt4, cluceneCore, redland}:

stdenv.mkDerivation {
  name = "soprano-2.4.0.1";
  
  src = fetchurl {
    url = mirror://sourceforge/soprano/soprano-2.4.0.1.tar.bz2;
    sha256 = "0124i92g3vky9wm8ripy3x4gnf1c4pz2hklisds9vld6ylj8gsa6";
  };
  
  # We disable the Java backends, since we do not need them and they make the closure size much bigger
  buildInputs = [ cmake qt4 cluceneCore redland ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
