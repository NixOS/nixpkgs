{ lib, stdenv, fetchurl, autoreconfHook, pkg-config
, openssl
, odbcSupport ? true, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation rec {
  pname = "freetds";
<<<<<<< HEAD
  version = "1.3.20";

  src = fetchurl {
    url    = "https://www.freetds.org/files/stable/${pname}-${version}.tar.bz2";
    sha256 = "sha256-IK4R87gG5PvA+gtZMftHO7V0i+6dSH9qoSiFCDV4pe0=";
=======
  version = "1.3.18";

  src = fetchurl {
    url    = "https://www.freetds.org/files/stable/${pname}-${version}.tar.bz2";
    sha256 = "sha256-HYVh1XxxmRoo9GgTQ3hcI6aj61TVvNI4l9B+OCX/LVY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [
    openssl
  ] ++ lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage    = "https://www.freetds.org";
<<<<<<< HEAD
    changelog   = "https://github.com/FreeTDS/freetds/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
