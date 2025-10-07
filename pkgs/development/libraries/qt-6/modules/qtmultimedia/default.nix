{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  qtquick3d,
  qtshadertools,
  qtsvg,
  pkg-config,
  alsa-lib,
  gstreamer,
  gst-plugins-bad,
  gst-plugins-base,
  gst-plugins-good,
  gst-libav,
  gst-vaapi,
  ffmpeg,
  libva,
  libpulseaudio,
  pipewire,
  wayland,
  libXrandr,
  elfutils,
  libunwind,
  orc,
}:

qtModule {
  pname = "qtmultimedia";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ffmpeg
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [
    libunwind
    orc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    pipewire
    alsa-lib
    wayland
    libXrandr
    libva
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [ elfutils ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [ qtquick3d ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gstreamer
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-libav
    gst-vaapi
  ];

  propagatedNativeBuildInputs = [ qtshadertools ];

  patches = lib.optionals stdenv.hostPlatform.isMinGW [
    ./windows-no-uppercase-libs.patch
    ./windows-resolve-function-name.patch
  ];

  cmakeFlags = [
    "-DENABLE_DYNAMIC_RESOLVE_VAAPI_SYMBOLS=0"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AudioToolbox";
}
