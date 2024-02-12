{ lib
, stdenv
, fetchurl
, pkg-config
, validatePkgConfig
, cairo
, curl
, fontconfig
, freetype
, freexl
, geos
, giflib
, libgeotiff
, libjpeg
, libpng
, librttopo
, libspatialite
, libtiff
, libwebp
, libxml2
, lz4
, minizip
, openjpeg
, pixman
, proj
, sqlite
, zstd
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "librasterlite2";
  version = "1.1.0-beta1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/librasterlite2-sources/librasterlite2-${version}.tar.gz";
    hash = "sha256-9yhM38B600OjFOSHjfAwCHSwFF2dMxsGOwlrSC5+RPQ=";
  };

  # Fix error: unknown type name 'time_t'
  postPatch = ''
    sed -i '49i #include <time.h>' headers/rasterlite2_private.h
  '';

  nativeBuildInputs = [
    pkg-config
    validatePkgConfig
    geos # for geos-config
  ];

  buildInputs = [
    cairo
    curl
    fontconfig
    freetype
    freexl
    giflib
    geos
    libgeotiff
    libjpeg
    libpng
    librttopo
    libspatialite
    libtiff
    libwebp
    libxml2
    lz4
    minizip
    openjpeg
    pixman
    proj
    sqlite
    zstd
  ] ++ lib.optional stdenv.isDarwin ApplicationServices;

  enableParallelBuilding = true;

  # Failed tests:
  # - check_sql_stmt
  doCheck = false;

  meta = with lib; {
    description = "Advanced library supporting raster handling methods";
    homepage = "https://www.gaia-gis.it/fossil/librasterlite2";
    # They allow any of these
    license = with licenses; [ gpl2Plus lgpl21Plus mpl11 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
