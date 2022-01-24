{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "unixODBC";
  version = "2.3.9";

  src = fetchurl {
    urls = [
      "ftp://ftp.unixodbc.org/pub/unixODBC/${pname}-${version}.tar.gz"
      "http://www.unixodbc.org/${pname}-${version}.tar.gz"
    ];
    sha256 = "sha256-UoM+rD1oHIsMmlpl8uvXRbOpZPII/HSPl35EAVoxsgc=";
  };

  configureFlags = [ "--disable-gui" "--sysconfdir=/etc" ];

  meta = with lib; {
    description = "ODBC driver manager for Unix";
    homepage = "http://www.unixodbc.org/";
    license = licenses.lgpl2;
    platforms = platforms.unix;
  };
}
