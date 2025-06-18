{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "wch-isp";
  version = "0.4.1";

  src = fetchFromSourcehut {
    owner = "~jmaselbas";
    repo = "wch-isp";
    rev = "v${version}";
    hash = "sha256-JB7cvZPzRhYJ8T3QJkguHOzZFrLOft5rRz0F0sVav/k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];
  installTargets = [
    "install"
    "install-rules"
  ];

  doInstallCheck = true;

  meta = {
    description = "Firmware programmer for WCH microcontrollers over USB";
    mainProgram = "wch-isp";
    license = lib.licenses.gpl2Only;
    homepage = "https://git.sr.ht/~jmaselbas/wch-isp";
    maintainers = with lib.maintainers; [ lesuisse ];
    platforms = lib.platforms.unix;
  };
}
