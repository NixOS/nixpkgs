{ lib, stdenv, fetchFromGitHub, pkg-config, libusb1 }:

stdenv.mkDerivation rec {
  pname = "wch-isp";
<<<<<<< HEAD
  version = "0.2.5";
=======
  version = "0.2.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jmaselbas";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-JF1g2Qb1gG93lSaDQvltT6jCYk/dKntsIJPkQXYUvX4=";
=======
    hash = "sha256-YjxzfDSZRMa7B+hNqtj87nRlRuQyr51VidZqHLddgwI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];
  installTargets = [ "install" "install-rules" ];

  meta = {
    description = "Firmware programmer for WCH microcontrollers over USB";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/jmaselbas/wch-isp";
    maintainers = with lib.maintainers; [ lesuisse ];
    platforms = lib.platforms.unix;
  };
}
