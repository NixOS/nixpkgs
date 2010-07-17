{stdenv, fetchurl, lib, cmake, qt4, cluceneCore, redland, libiodbc}:

stdenv.mkDerivation rec {
  name = "soprano-2.4.63";

  src = fetchurl {
    url = "mirror://sf/soprano/${name}.tar.bz2";
    sha256 = "0iqs0dy5d0pgf2x3vpigwvs8vp7mvfvzimkdw7dvqlqbbld05qbf";
  };

  # We disable the Java backend, since we do not need them and they make the closure size much bigger
  buildInputs = [ cmake qt4 cluceneCore redland libiodbc ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with lib.maintainers; [ sander urkud ];
    platforms = qt4.meta.platforms;
  };
}
