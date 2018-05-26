{ stdenv, fetchurl, lcms2, jasper, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libraw-${version}";
  version = "0.18.11";

  src = fetchurl {
    url = "http://www.libraw.org/data/LibRaw-${version}.tar.gz";
    sha256 = "07a7k83hx7icahh6jaxfbd7pw5jjm5i11xcqjj31b28d1aj29xvw";
  };

  outputs = [ "out" "lib" "dev" "doc" ];

  buildInputs = [ jasper ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = https://www.libraw.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}

