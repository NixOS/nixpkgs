{ stdenv, fetchFromGitHub
, avrgcc, avrbinutils
, gcc-arm-embedded, binutils-arm-embedded
, teensy-loader-cli, dfu-programmer, dfu-util }:

let version = "0.6.144";

in stdenv.mkDerivation {
  name = "qmk_firmware-${version}";
  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    rev = version;
    sha256 = "0m71f9w32ksqjkrwhqwhr74q5v3pr38bihjyb9ks0k5id0inhrjn";
    fetchSubmodules = true;
  };
  buildFlags = "all:default";
  NIX_CFLAGS_COMPILE = "-Wno-error";
  nativeBuildInputs = [
    avrgcc
    avrbinutils
    gcc-arm-embedded
    teensy-loader-cli
    dfu-programmer
    dfu-util
  ];
}
