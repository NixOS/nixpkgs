{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
  libftdi1,
}:

stdenv.mkDerivation {
  pname = "xvcd";
  version = "2026.07.09.e24745d";

  src = fetchFromGitHub {
    owner = "tmbinc";
    repo = "xvcd";
    rev = "e24745d5fe29b52d30e5c08cda4f2ecdf4909abb";
    hash = "sha256-/O1Oal3RBqCNTgTzvFkq6DkUJH8rHWQyuoCu3e97tro=";
  };

  buildInputs = [
    libusb1
    libftdi1
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv bin/xvcd $out/bin/
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Xilinx Virtual Cable server";
    homepage = "https://github.com/tmbinc/xvcd";
    license = lib.licenses.cc0;
    mainProgram = "xvcd";
    maintainers = with lib.maintainers; [ feyorsh ];
    platforms = lib.platforms.unix;
  };
}
