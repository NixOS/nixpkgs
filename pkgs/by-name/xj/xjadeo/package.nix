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

stdenv.mkDerivation rec {
  pname = "xjadeo";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "xjadeo";
    rev = "v${version}";
    sha256 = "sha256-GTg0W3D0BRSxsmeVsB4On3MfwncScEGFJGVJK7wflCM=";
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

  meta = with lib; {
    description = "X Jack Video Monitor";
    longDescription = ''
      Xjadeo is a software video player that displays a video-clip in sync with
      an external time source (MTC, LTC, JACK-transport). Xjadeo is useful in
      soundtrack composition, video monitoring or any task that requires to
      synchronizing movie frames with external events.
    '';
    homepage = "https://xjadeo.sourceforge.net";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mitchmindtree ];
  };
}
