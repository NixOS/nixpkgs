{stdenv, fetchurl, lib, cmake, qt4, cluceneCore, redland}:

stdenv.mkDerivation {
  name = "soprano-2.2.3";
  
  src = fetchurl {
    url = mirror://sourceforge/soprano/soprano-2.3.0.tar.bz2;
    sha256 = "8a563a5a4b00169ef84fb1b69e76d3657ee7f5a94a6a35c9600f510f55fa275c";
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
