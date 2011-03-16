{stdenv, fetchurl, cmake, qt4, cluceneCore, redland, libiodbc, pkgconfig}:

stdenv.mkDerivation rec {
  name = "soprano-2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/soprano/${name}.tar.bz2";
    sha256 = "0dfdc4hcv25kwmv3wp13qjw2jg2fax4gcy79yia7sdgz5ik59xq2";
  };

  # We disable the Java backend, since we do not need them and they make the closure size much bigger
  buildInputs = [ qt4 cluceneCore redland libiodbc ];
  buildNativeInputs = [ cmake pkgconfig ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (qt4.meta) platforms;
  };
}
