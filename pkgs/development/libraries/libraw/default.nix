{ stdenv, fetchurl, lcms2, jasper, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libraw-${version}";
  version = "0.17.1";

  src = fetchurl {
    url = "http://www.libraw.org/data/LibRaw-${version}.tar.gz";
    sha256 = "18fygk896gxbx47nh2rn5jp4skisgkl6pdfjqb7h0zn39hd6b6g5";
  };

  buildInputs = [ jasper ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = http://www.libraw.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}

