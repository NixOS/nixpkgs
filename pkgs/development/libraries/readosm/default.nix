{ lib, stdenv, fetchurl, expat, zlib, geos, libspatialite }:

stdenv.mkDerivation rec {
  pname = "readosm";
  version = "1.1.0a";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/readosm-sources/${pname}-${version}.tar.gz";
    sha256 = "0igif2bxf4dr82glxz9gyx5mmni0r2dsnx9p9k6pxv3c4lfhaz6v";
  };

  buildInputs = [ expat zlib geos libspatialite ];

  configureFlags = [ "--disable-freexl" ];

  enableParallelBuilding = true;

  meta = {
    description = "An open source library to extract valid data from within an Open Street Map input file";
    homepage = "https://www.gaia-gis.it/fossil/readosm";
    license = with lib.licenses; [ mpl11 gpl2Plus lgpl21Plus ];
    platforms = lib.platforms.linux;
  };
}
