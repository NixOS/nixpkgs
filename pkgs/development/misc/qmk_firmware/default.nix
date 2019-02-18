{ stdenv, fetchFromGitHub
, avrgcc, avrbinutils
, gcc-arm-embedded, gcc-armhf-embedded
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
  postPatch = ''
    substituteInPlace tmk_core/arm_atsam.mk \
      --replace arm-none-eabi arm-none-eabihf
    rm keyboards/handwired/frenchdev/rules.mk keyboards/dk60/rules.mk
  '';
  buildFlags = "all:default";
  doCheck = true;
  checkTarget = "test:all";
  installPhase = ''
    mkdir $out
  '';
  NIX_CFLAGS_COMPILE = "-Wno-error";
  nativeBuildInputs = [
    avrgcc
    avrbinutils
    gcc-arm-embedded
    gcc-armhf-embedded
    teensy-loader-cli
    dfu-programmer
    dfu-util
  ];
}
