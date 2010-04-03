{stdenv, fetchurl, lib, cmake, qt4, cluceneCore, redland, libiodbc}:

stdenv.mkDerivation rec {
  name = "soprano-2.4.1";
  
  src = fetchurl {
    url = "mirror://sf/soprano/${name}.tar.bz2";
    sha256 = "1ghwjbcrbwhq0in61a47iaxcja50r9axsg9cv97x2myprrqa43bj";
  };
  
  # We disable the Java backends, since we do not need them and they make the closure size much bigger
  buildInputs = [ cmake qt4 cluceneCore redland libiodbc ];

  meta = {
    homepage = http://soprano.sourceforge.net/;
    description = "An object-oriented C++/Qt4 framework for RDF data";
    license = "LGPL";
    maintainers = with lib.maintainers; [ sander urkud ];
  };
}
