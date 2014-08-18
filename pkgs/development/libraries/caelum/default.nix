{ stdenv, fetchurl, cmake, pkgconfig, ois, ogre, boost }:

stdenv.mkDerivation rec {
  name = "caelum-0.6.1";

  src = fetchurl {
    url = "http://caelum.googlecode.com/files/${name}.tar.gz";
    sha256 = "1j995q1a88cikqrxdqsrwzm2asid51xbmkl7vn1grfrdadb15303";
  };

  buildInputs = [ ois ogre boost ];
  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    description = "Add-on for the OGRE, aimed to render atmospheric effects";
    homepage = http://code.google.com/p/caelum/;
    license = "LGPLv2.1+";
    broken = true;
  };
}
