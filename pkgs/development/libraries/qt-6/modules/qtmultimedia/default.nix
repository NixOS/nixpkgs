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
  ffmpeg,
  libva,
  libpulseaudio,
  pipewire,
  wayland,
  libxrandr,
  elfutils,
  libunwind,
  orc,
  pkgsBuildBuild,
  # TODO: Clean up on `staging`.
  llvmPackages,
}:

qtModule {
  pname = "qtmultimedia";
  nativeBuildInputs = [
    pkg-config
  ]
  # TODO: Clean up on `staging`.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.lld
  ];
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
    libxrandr
    libva
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [ elfutils ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtshadertools
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [ qtquick3d ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gstreamer
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-libav
  ];

  patches = lib.optionals stdenv.hostPlatform.isMinGW [
    ./windows-no-uppercase-libs.patch
    ./windows-resolve-function-name.patch
  ];

  cmakeFlags = [
    "-DENABLE_DYNAMIC_RESOLVE_VAAPI_SYMBOLS=0"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];

  env = {
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-include AudioToolbox/AudioToolbox.h";
    # TODO: Clean up on `staging`.
    NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-fuse-ld=lld";
    NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AudioToolbox";
  };
}
