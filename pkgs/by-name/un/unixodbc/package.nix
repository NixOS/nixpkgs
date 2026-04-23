{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unixobcd";
  version = "2.3.12";

  # TODO: build from source https://github.com/lurcher/unixODBC
  src = fetchurl {
    urls = [
      "ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-${finalAttrs.version}.tar.gz"
      "https://www.unixodbc.org/unixODBC-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "sha256-8hBQFEXOIb9ge6Ue+MEl4Q4i3/3/7Dd2RkYt9fAZFew=";
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
})
