{stdenv, fetchurl, cmake, qt4}:

stdenv.mkDerivation {
  name = "attica-0.1.2";
  src = fetchurl {
    url = mirror://kde/stable/attica/attica-0.1.2.tar.bz2;
    sha256 = "09k7ghphqzfdlnsj61396sgmyzjqz9l6a8703y29292yc4h7qmxh";
  };
  buildInputs = [ cmake qt4 ];
  meta = {
    description = "A library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}