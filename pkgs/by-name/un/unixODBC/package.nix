{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.14";

  src = fetchurl {
    urls = [
      "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz"
      "https://www.unixodbc.org/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-TigU3j4B/DCwufdeg7taupGrA4TulRKGUEu3AgVSR3E=";
  };

  configureFlags = [
    "--disable-gui"
    "--sysconfdir=/etc"
  ];

  meta = {
    description = "ODBC driver manager for Unix";
    homepage = "https://www.unixodbc.org/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
