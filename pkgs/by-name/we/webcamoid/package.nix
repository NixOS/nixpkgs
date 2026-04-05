{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxcb,
  cmake,
  qt6,
  ffmpeg,
  gst_all_1,
  libpulseaudio,
  alsa-lib,
  jack2,
  v4l-utils,
}:

stdenv.mkDerivation rec {
  pname = "webcamoid";
  version = "9.3.0";

  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "webcamoid";
    tag = version;
    hash = "sha256-KU5iJqCGbqTZebP5yWb5VcxRGcRjQYQHn+GP6W57D9I=";
  };

  buildInputs = [
    libxcb
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    ffmpeg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    alsa-lib
    libpulseaudio
    jack2
    v4l-utils
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
  ];

  meta = {
    description = "Webcam Capture Software";
    longDescription = "Webcamoid is a full featured and multiplatform webcam suite.";
    homepage = "https://github.com/webcamoid/webcamoid/";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ robaca ];
    mainProgram = "webcamoid";
  };
}
