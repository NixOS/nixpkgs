{
  lib,
  stdenv,
  fetchurl,
  validatePkgConfig,
  libpq,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virtualpg";
  version = "2.0.1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/virtualpg-${finalAttrs.version}.tar.gz";
    hash = "sha256-virr64yf8nQ4IIX1HUIugjhYvKT2vC+pCYFkZMah4Is=";
  };

  nativeBuildInputs = [
    validatePkgConfig
    libpq.pg_config
  ];

  buildInputs = [
    libpq
    sqlite
  ];

  meta = {
    description = "Loadable dynamic extension to both SQLite and SpatiaLite";
    homepage = "https://www.gaia-gis.it/fossil/virtualpg";
    license = with lib.licenses; [
      mpl11
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
