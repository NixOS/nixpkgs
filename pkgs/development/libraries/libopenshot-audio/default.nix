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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopenshot-audio";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "libopenshot-audio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FTSITx6GoH1cGWeWNWtz1Ih+zozK8aA+u54Y4s0DylQ=";
  };

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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
