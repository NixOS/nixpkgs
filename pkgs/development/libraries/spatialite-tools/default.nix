{ lib, stdenv, fetchurl, pkg-config, sqlite, expat, zlib, proj, geos, libspatialite, readosm }:

stdenv.mkDerivation rec {
  name = "spatialite-tools-4.1.1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/${name}.tar.gz";
    sha256 = "14aqmhvab63ydbb82fglsbig7jw1wmci8jjvci07aavdhvh1pyrv";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite expat zlib proj geos libspatialite readosm ];

  configureFlags = [ "--disable-freexl" ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lsqlite3";

  meta = {
    description = "A complete sqlite3-compatible CLI front-end for libspatialite";
    homepage = "https://www.gaia-gis.it/fossil/spatialite-tools";
    license = with lib.licenses; [ mpl11 gpl2Plus lgpl21Plus ];
    platforms = lib.platforms.linux;
  };
}
