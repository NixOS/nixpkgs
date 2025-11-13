{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  ffmpeg,
  freetype,
  libGLU,
  libjack2,
  liblo,
  libX11,
  libXv,
  pkg-config,
  portmidi,
  xorg,
}:

stdenv.mkDerivation {
  pname = "xjadeo";
  version = "0.8.14-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "xjadeo";
    rev = "88dbd570148f05956ce9dcc49d4957250d516c7c";
    hash = "sha256-SFP1uYaPEN9eqB4xaN6V17OGQrOF4ZyBM8NiZ+tSuYY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    libjack2
    libX11
    xorg.libXext
    xorg.libXpm
    # The following are recommended in the README, but are seemingly
    # unnecessary for a successful build. That said, the result of including
    # these in the build process is possibly required at runtime in some cases,
    # but I've not the time to test thoroughly for these cases. Should
    # consider investigating and splitting these into options in the future.
    freetype
    libGLU
    liblo
    libXv
    portmidi
  ];

  meta = {
    description = "X Jack Video Monitor";
    longDescription = ''
      Xjadeo is a software video player that displays a video-clip in sync with
      an external time source (MTC, LTC, JACK-transport). Xjadeo is useful in
      soundtrack composition, video monitoring or any task that requires to
      synchronizing movie frames with external events.
    '';
    homepage = "https://xjadeo.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mitchmindtree ];
  };
}
