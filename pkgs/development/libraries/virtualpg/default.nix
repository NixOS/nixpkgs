{ lib, stdenv, fetchurl, validatePkgConfig, postgresql, sqlite, darwin }:

stdenv.mkDerivation rec {
  pname = "virtualpg";
  version = "2.0.1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/virtualpg-${version}.tar.gz";
    hash = "sha256-virr64yf8nQ4IIX1HUIugjhYvKT2vC+pCYFkZMah4Is=";
  };

  nativeBuildInputs = [
    validatePkgConfig
    postgresql  # for pg_config
  ];

  buildInputs = [ postgresql sqlite ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Kerberos ];

  meta = with lib; {
    description = "Loadable dynamic extension to both SQLite and SpatiaLite";
    homepage = "https://www.gaia-gis.it/fossil/virtualpg";
    license = with licenses; [ mpl11 gpl2Plus lgpl21Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
