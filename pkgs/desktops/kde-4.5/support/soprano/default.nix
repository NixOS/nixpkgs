{stdenv, fetchurl, cmake, qt4, cluceneCore, redland, libiodbc}:

stdenv.mkDerivation rec {
  name = "soprano-2.4.64";

  src = fetchurl {
    url = "mirror://sf/soprano/${name}.tar.bz2";
    sha256 = "1jrpgp573r2q20v108a0528f92n7g892pdr44fgskcq7wf8l8mzv";
  };

  # We disable the Java backend, since we do not need them and they make the closure size much bigger
  buildInputs = [ cmake qt4 cluceneCore redland libiodbc ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (qt4.meta) platforms;
  };
}
