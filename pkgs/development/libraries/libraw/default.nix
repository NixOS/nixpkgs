{ stdenv, fetchurl, lcms2, jasper, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libraw-0.16.0";

  src = fetchurl {
    url = http://www.libraw.org/data/LibRaw-0.16.0.tar.gz;
    sha256 = "15ng4s24grib39r0nlgrf18r2j9yh43qyx4vbif38d95xiqkix3i";
  };

  buildInputs = [ lcms2 jasper ] ;

  nativeBuildInputs = [ pkgconfig ];

  meta = { 
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = http://www.libraw.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}

