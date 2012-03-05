{ stdenv, fetchurl, cmake, qt4, clucene_core, librdf_redland, libiodbc
, pkgconfig }:

stdenv.mkDerivation rec {
  name = "soprano-2.7.5";

  src = fetchurl {
    url = "mirror://sourceforge/soprano/${name}.tar.bz2";
    sha256 = "0g9vi4z82dwz0hkg3b9gvi11akji1mzphjxwz3fw55213c0f0a3c";
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
