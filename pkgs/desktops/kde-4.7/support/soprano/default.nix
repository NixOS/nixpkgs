{stdenv, fetchurl, cmake, qt4, cluceneCore, redland, libiodbc}:

stdenv.mkDerivation rec {
  name = "soprano-2.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/soprano/${name}.tar.bz2";
    sha256 = "0hxc6jnbh0529jsc0ixvy8pshnffrpgsadinhk9navkpyn5xg4l9";
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
