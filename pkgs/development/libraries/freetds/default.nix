{ lib, stdenv, fetchurl, autoreconfHook, pkg-config
, openssl
, odbcSupport ? true, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation rec {
  pname = "freetds";
  version = "1.3.13";

  src = fetchurl {
    url    = "https://www.freetds.org/files/stable/${pname}-${version}.tar.bz2";
    sha256 = "sha256-1M+QCUFR/c3aEo7RjLCmv2WzCL41K1NEmUO1JJxbSPI=";
  };

  buildInputs = [
    openssl
  ] ++ lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage    = "https://www.freetds.org";
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
