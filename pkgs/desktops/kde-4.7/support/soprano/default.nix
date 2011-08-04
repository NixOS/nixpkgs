{ stdenv, fetchurl, cmake, qt4, clucene_core, redland, libiodbc }:

stdenv.mkDerivation rec {
  name = "soprano-2.6.51";

  src = fetchurl {
    url = "mirror://sourceforge/soprano/${name}.tar.bz2";
    sha256 = "0sj0cklxahlhig29d0b1a3hr1p2z1xfar7j1slj2klbcy3qn47i0";
  };

  # We disable the Java backend, since we do not need them and they make the closure size much bigger
  buildInputs = [ cmake qt4 clucene_core redland libiodbc ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (qt4.meta) platforms;
  };
}
