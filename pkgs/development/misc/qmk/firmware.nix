{ stdenv
, lib
, fetchFromGitHub
, avrgcc
, avrbinutils
, gcc-arm-embedded
, gcc-armhf-embedded
, teensy-loader-cli
, dfu-programmer
, dfu-util
}:

stdenv.mkDerivation rec {
  pname = "qmk_firmware";
  version = "0.11.49";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = pname;
    rev = version;
    hash = "sha256-E/oe5u6F9pxvavRLlrXmr9kCc6pSdSmQgtg4a3wbIuA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace tmk_core/arm_atsam.mk \
      --replace arm-none-eabi arm-none-eabihf
  '';

  nativeBuildInputs = [
    avrgcc
    avrbinutils
    gcc-arm-embedded
    gcc-armhf-embedded
    teensy-loader-cli
    dfu-programmer
    dfu-util
  ];

  buildFlags = [ "all:default" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  doCheck = true;

  checkTarget = "test:all";

  preInstall = ''
    mkdir $out
  '';

  meta = with lib; {
    homepage = "https://qmk.fm";
    description = "Open-source keyboard firmware for ATMEL AVR and ARM USB families";
    longDescription = ''
      QMK (Quantum Mechanical Keyboard) is an open source community centered
      around developing computer input devices. The community encompasses all
      sorts of input devices, such as keyboards, mice, and MIDI devices. A core
      group of collaborators maintains QMK Firmware, QMK Configurator, QMK
      Toolbox, qmk.fm, and this documentation with the help of community members
      like you.
    '';
    license = with licenses; gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    broken = true;
  };
}
