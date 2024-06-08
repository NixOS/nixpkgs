{ lib, stdenv, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, jack2
, libpulseaudio
, sndio
, speexdsp
, AudioUnit
, CoreAudio
, CoreServices
, lazyLoad ? !stdenv.isDarwin
}:

assert lib.assertMsg (stdenv.isDarwin -> !lazyLoad) "cubeb: lazyLoad is inert on Darwin";

let
  backendLibs = [
    alsa-lib
    jack2
    libpulseaudio
    sndio
  ];

in stdenv.mkDerivation {
  pname = "cubeb";
  version = "unstable-2022-10-18";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cubeb";
    rev = "27d2a102b0b75d9e49d43bc1ea516233fb87d778";
    hash = "sha256-q+uz1dGU4LdlPogL1nwCR/KuOX4Oy3HhMdA6aJylBRk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ speexdsp ] ++ (
    if stdenv.isDarwin then [ AudioUnit CoreAudio CoreServices ]
    else backendLibs
  );

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_TESTS=OFF" # tests require an audio server
    "-DBUNDLE_SPEEX=OFF"
    "-DUSE_SANITIZERS=OFF"

    # Whether to lazily load libraries with dlopen()
    "-DLAZY_LOAD_LIBS=${if lazyLoad then "ON" else "OFF"}"
  ];

  passthru = {
    # For downstream users when lazyLoad is true
    backendLibs = lib.optionals lazyLoad backendLibs;
  };

  meta = with lib; {
    description = "Cross platform audio library";
    mainProgram = "cubeb-test";
    homepage = "https://github.com/mozilla/cubeb";
    license = licenses.isc;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
