{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  cmake,
  doxygen,
  libX11,
  libXcursor,
  libXext,
  libXft,
  libXinerama,
  libXrandr,
  pkg-config,
  zlib,
  Accelerate,
  AGL,
  Cocoa,
  Foundation,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot-audio";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9iHeVMoyzTQae/PVYJqON0qOPo3SJlhrqbcp2u1Y8MA=";
  };

  patches = [
    # https://forum.juce.com/t/juce-and-macos-11-arm/40285/24
    ./0001-undef-fpret-on-aarch64-darwin.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
    ]
    ++ (
      if stdenv.hostPlatform.isDarwin then
        [
          Accelerate
          AGL
          Cocoa
          Foundation
          zlib
        ]
      else
        [
          libX11
          libXcursor
          libXext
          libXft
          libXinerama
          libXrandr
        ]
    );

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "http://openshot.org/";
    description = "High-quality sound editing library";
    mainProgram = "openshot-audio-demo";
    longDescription = ''
      OpenShot Audio Library (libopenshot-audio) is a program that allows the
      high-quality editing and playback of audio, and is based on the amazing
      JUCE library.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
