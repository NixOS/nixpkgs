{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.11";

  src = fetchurl {
    urls = [
      "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz"
      "https://www.unixodbc.org/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-2eVcjnEYNH48ZshzOIVtrRUWtJD7fHVsFWKiwmfHO1w=";
  };

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with lib; {
    description = "ODBC driver manager for Unix";
    homepage = "https://www.unixodbc.org/";
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
