{ lib
, stdenv
, fetchurl
, pkg-config
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
  version = "5.0.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/${pname}-${version}.tar.gz";
    sha256 = "sha256-7svJQxHHgBLQWevA+uhupe9u7LEzA+boKzdTwbNAnpg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    geos
    librttopo
    libxml2
    minizip
    proj
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
  ];

  configureFlags = [ "--disable-freexl" ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.isDarwin ''
    ln -s $out/lib/mod_spatialite.{so,dylib}
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
