{
  lib,
  stdenv,
  fetchurl,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.14";

  src = fetchurl {
    urls = [
      # GitHub tag format changed from "2.3.12" to "v2.3.13" starting with 2.3.13
      "https://github.com/lurcher/unixODBC/releases/download/${
        if lib.versionAtLeast version "2.3.13" then "v${version}" else version
      }/${pname}-${version}.tar.gz"
      "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz"
      "https://www.unixodbc.org/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-TigU3j4B/DCwufdeg7taupGrA4TulRKGUEu3AgVSR3E=";
  };

  configureFlags = [
    "--disable-gui"
    "--sysconfdir=/etc"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=^v?([0-9.]+)$"
    ];
  };

  meta = {
    description = "ODBC driver manager for Unix";
    homepage = "https://www.unixodbc.org/";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
