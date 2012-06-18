{ stdenv, fetchurl, cmake, qt4, clucene_core, librdf_redland, libiodbc
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "soprano-2.7.6";

  src = fetchurl {
    url = "mirror://sourceforge/soprano/${name}.tar.bz2";
    sha256 = "0cnprxc8wykl96aphsh2d3711h7cals7gnibbxpsmsqyqbnhbp98";
  };

  patches = [ ./find-virtuoso.patch ];

  # We disable the Java backend, since we do not need them and they make the closure size much bigger
  buildInputs = [ qt4 clucene_core librdf_redland libiodbc ];

  buildNativeInputs = [ cmake pkgconfig ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (qt4.meta) platforms;
  };
}
