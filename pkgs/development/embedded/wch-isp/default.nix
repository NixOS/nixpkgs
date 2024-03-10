{ lib, stdenv, fetchFromGitHub, pkg-config, libusb1 }:

stdenv.mkDerivation rec {
  pname = "wch-isp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jmaselbas";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cTePTpzvWf2DdInhBxFY72aVNb0SAlCHb/tUwNqqX1U=";
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
