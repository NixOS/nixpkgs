{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  libevent,
  libjpeg,
  libdrm,
  pkg-config,
  janus-gateway,
  glib,
  alsa-lib,
  speex,
  jansson,
  libopus,
  nixosTests,
  systemdLibs,
  which,
  withSystemd ? true,
  withJanus ? true,
}:
stdenv.mkDerivation rec {
  pname = "ustreamer";
  version = "6.18";

  src = fetchFromGitHub {
    owner = "pikvm";
    repo = "ustreamer";
    rev = "v${version}";
    hash = "sha256-VzhTfr0Swrv3jZUvBYYy5l0+iSokIztpeyA1CuG/roY=";
  };

  buildInputs =
    [
      libbsd
      libevent
      libjpeg
      libdrm
    ]
    ++ lib.optionals withSystemd [
      systemdLibs
    ]
    ++ lib.optionals withJanus [
      janus-gateway
      glib
      alsa-lib
      jansson
      speex
      libopus
    ];

  nativeBuildInputs = [
    pkg-config
    which
  ];

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
      "WITH_V4P=1"
    ]
    ++ lib.optionals withSystemd [
      "WITH_SYSTEMD=1"
    ]
    ++ lib.optionals withJanus [
      "WITH_JANUS=1"
      # Workaround issues with Janus C Headers
      # https://github.com/pikvm/ustreamer/blob/793f24c4/docs/h264.md#fixing-janus-c-headers
      "CFLAGS=-I${lib.getDev janus-gateway}/include/janus"
    ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) ustreamer; };

  meta = with lib; {
    homepage = "https://github.com/pikvm/ustreamer";
    description = "Lightweight and fast MJPG-HTTP streamer";
    longDescription = ''
      µStreamer is a lightweight and very quick server to stream MJPG video from
      any V4L2 device to the net. All new browsers have native support of this
      video format, as well as most video players such as mplayer, VLC etc.
      µStreamer is a part of the Pi-KVM project designed to stream VGA and HDMI
      screencast hardware data with the highest resolution and FPS possible.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      tfc
      matthewcroughan
    ];
    platforms = platforms.linux;
    mainProgram = "ustreamer";
  };
}
