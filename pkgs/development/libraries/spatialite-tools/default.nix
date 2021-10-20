{ lib
, stdenv
, fetchurl
, pkg-config
, geos
, expat
, librttopo
, libspatialite
, libxml2
, minizip
, proj
, readosm
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "spatialite-tools";
  version = "5.0.1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/${pname}-${version}.tar.gz";
    sha256 = "sha256-lgTCBeh/A3eJvFIwLGbM0TccPpjHTo7E4psHUt41Fxw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    geos
    librttopo
    libspatialite
    libxml2
    minizip
    proj
    readosm
    sqlite
  ];

  configureFlags = [ "--disable-freexl" ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = "-lsqlite3";

  meta = with lib; {
    description = "A complete sqlite3-compatible CLI front-end for libspatialite";
    homepage = "https://www.gaia-gis.it/fossil/spatialite-tools";
    license = with licenses; [ mpl11 gpl2Plus lgpl21Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
