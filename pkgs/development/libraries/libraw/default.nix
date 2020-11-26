{ stdenv, fetchurl, lcms2, pkgconfig
, jasper ? null, withJpeg2k ? false
# disable JPEG2000 support by default as jasper has many CVE
}:

stdenv.mkDerivation rec {
  pname = "libraw";
  version = "0.20.0";

  src = fetchurl {
    url = "https://www.libraw.org/data/LibRaw-${version}.tar.gz";
    sha256 = "18wlsvj6c1rv036ph3695kknpgzc3lk2ikgshy8417yfl8ykh2hz";
  };

  outputs = [ "out" "lib" "dev" "doc" ];

  buildInputs = stdenv.lib.optionals withJpeg2k [ jasper ];

  propagatedBuildInputs = [ lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Library for reading RAW files obtained from digital photo cameras (CRW/CR2, NEF, RAF, DNG, and others)";
    homepage = "https://www.libraw.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}

