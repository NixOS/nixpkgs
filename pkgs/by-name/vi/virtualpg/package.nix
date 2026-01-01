{
  lib,
  stdenv,
  fetchurl,
  validatePkgConfig,
  libpq,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "virtualpg";
  version = "2.0.1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/virtualpg-${version}.tar.gz";
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

<<<<<<< HEAD
  meta = {
    description = "Loadable dynamic extension to both SQLite and SpatiaLite";
    homepage = "https://www.gaia-gis.it/fossil/virtualpg";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Loadable dynamic extension to both SQLite and SpatiaLite";
    homepage = "https://www.gaia-gis.it/fossil/virtualpg";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mpl11
      gpl2Plus
      lgpl21Plus
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
=======
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
