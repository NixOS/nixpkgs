{ stdenv, fetchurl, expat, zlib, geos, libspatialite }:

stdenv.mkDerivation rec {
  name = "readosm-1.0.0b";

  src = fetchurl {
    url = "http://www.gaia-gis.it/gaia-sins/readosm-sources/${name}.tar.gz";
    sha256 = "042pv31smc7l6y111rvp0hza5sw86wa8ldg2jyq78xgwzcbhszpd";
  };

  buildInputs = [ expat zlib geos libspatialite ];

  configureFlags = "--disable-freexl";

  enableParallelBuilding = true;

  meta = {
    description = "An open source library to extract valid data from within an Open Street Map input file";
    homepage = https://www.gaia-gis.it/fossil/readosm;
    license = with stdenv.lib.licenses; [ mpl11 gpl2Plus lgpl21Plus ];
    platforms = stdenv.lib.platforms.linux;
  };
}
