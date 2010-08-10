{stdenv, fetchurl, cmake, qt4, cluceneCore, redland, libiodbc}:

stdenv.mkDerivation rec {
  name = "soprano-2.5.0";

  src = fetchurl {
    url = "mirror://sf/soprano/${name}.tar.bz2";
    sha256 = "01g0shwxksr6mg2g1pj1pbwz6nir5rw16ysmmly85891p62j8nxn";
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
