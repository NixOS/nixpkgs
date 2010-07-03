{stdenv, fetchurl, lib, cmake, qt4, cluceneCore, redland, libiodbc}:

stdenv.mkDerivation rec {
  name = "soprano-2.4.4";
  
  src = fetchurl {
    url = "mirror://sf/soprano/${name}.tar.bz2";
    sha256 = "02qi616w6kli75ibkrvjc88spx6hi8ahlf3c926bi4lh5h73pjkq";
  };
  
  # We disable the Java backends, since we do not need them and they make the closure size much bigger
  buildInputs = [ cmake qt4 cluceneCore redland libiodbc ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with lib.maintainers; [ sander urkud ];
    platforms = qt4.meta.platforms;
  };
}
