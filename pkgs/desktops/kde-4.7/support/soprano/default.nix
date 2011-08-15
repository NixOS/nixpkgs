{ stdenv, fetchurl, cmake, qt4, clucene_core, redland, libiodbc }:

stdenv.mkDerivation rec {
  name = "soprano-2.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/soprano/${name}.tar.bz2";
    sha256 = "1ki92wg0i9nhn1fh5mdcls5h9h3lf2k5r66snsags4x7zw0dmv2z";
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
