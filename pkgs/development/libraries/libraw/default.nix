{ stdenv, fetchurl, lcms2, jasper, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libraw-${version}";
  version = "0.19.2";

  src = fetchurl {
    url = "https://www.libraw.org/data/LibRaw-${version}.tar.gz";
    sha256 = "0i4nhjm5556xgn966x0i503ygk2wafq6z83kg0lisacjjab4f3a0";
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

