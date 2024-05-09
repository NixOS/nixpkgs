{ lib, stdenv, fetchurl, autoreconfHook, pkg-config
, openssl
, odbcSupport ? true, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation rec {
  pname = "freetds";
  version = "1.4.11";

  src = fetchurl {
    url    = "https://www.freetds.org/files/stable/${pname}-${version}.tar.bz2";
    hash   = "sha256-Vn986RPyIhkd2n4cIh1eJyo4cVL+9srL2Xdn/qaLYT4=";
  };

  buildInputs = [
    openssl
  ] ++ lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage    = "https://www.freetds.org";
    changelog   = "https://github.com/FreeTDS/freetds/releases/tag/v${version}";
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
