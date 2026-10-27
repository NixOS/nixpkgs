{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  scdoc,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wch-isp";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~jmaselbas";
    repo = "wch-isp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4IY3obL/Udw+e3m7LWkRZxVzZxl+hTc4B8ui4dmWOCE=";
  };

  nativeBuildInputs = [
    pkg-config
    scdoc
  ];
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
})
