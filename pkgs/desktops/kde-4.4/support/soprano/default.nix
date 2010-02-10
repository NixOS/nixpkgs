{stdenv, fetchurl, lib, cmake, qt4, cluceneCore, redland}:

stdenv.mkDerivation {
  name = "soprano-2.4.0";
  
  src = fetchurl {
    url = mirror://sourceforge/soprano/soprano-2.4.0.tar.bz2;
    sha256 = "1630wax4baab5cl40xlvq6pj4scgmspmgb7wyyp7ppph4b0a8dkz";
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
