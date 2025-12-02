{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.12";

  src = fetchurl {
    urls = [
      "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz"
      "https://www.unixodbc.org/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-8hBQFEXOIb9ge6Ue+MEl4Q4i3/3/7Dd2RkYt9fAZFew=";
  };

  configureFlags = [
    "--disable-gui"
    "--sysconfdir=/etc"
  ];

  meta = with lib; {
    description = "ODBC driver manager for Unix";
    homepage = "https://www.unixodbc.org/";
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
