{ lib
, stdenv
, fetchurl
, pkg-config
, validatePkgConfig
, freexl
, geos
, librttopo
, libxml2
, minizip
, proj
, sqlite
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "libspatialite";
  version = "5.1.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-${version}.tar.gz";
    hash = "sha256-Q74t00na/+AW3RQAxdEShYKMIv6jXKUQnyHz7VBgUIA=";
  };

  nativeBuildInputs = [
    pkg-config
    validatePkgConfig
    geos # for geos-config
  ];

  buildInputs = [
    freexl
    geos
    librttopo
    libxml2
    minizip
    proj
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/mod_spatialite.{so,dylib}
  '';

  # Failed tests (linux & darwin):
  # - check_virtualtable6
  # - check_drop_rename
  doCheck = false;

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)/src/.libs
    export DYLD_LIBRARY_PATH=$(pwd)/src/.libs
  '';

  meta = with lib; {
    description = "Extensible spatial index library in C++";
    homepage = "https://www.gaia-gis.it/fossil/libspatialite";
    # They allow any of these
    license = with licenses; [ gpl2Plus lgpl21Plus mpl11 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
