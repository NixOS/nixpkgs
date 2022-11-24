{ lib, stdenv, fetchFromGitHub
, cmake
, pkg-config
, jack2
, pulseaudio
, sndio
, speexdsp
, lazyLoad ? true
}:

stdenv.mkDerivation {
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

  buildInputs = [
    jack2
    pulseaudio
    sndio
    speexdsp
  ];

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
    backendLibs = [ jack2 pulseaudio sndio speexdsp ];
  };

  meta = with lib; {
    description = "Cross platform audio library";
    homepage = "https://github.com/mozilla/cubeb";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
