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
  libsysprof-capture,
  wayland,
  libxrandr,
  openssl,
  elfutils,
  libunwind,
  orc,
  pkgsBuildBuild,
  replaceVars,
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
    libxrandr
    libva
    libsysprof-capture
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
    gst-vaapi
  ];

  patches = lib.optionals stdenv.hostPlatform.isMinGW [
    ./windows-no-uppercase-libs.patch
    ./windows-resolve-function-name.patch
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf $out/lib/libQt6Multimedia.so \
      --add-rpath ${
        lib.makeLibraryPath [
          pipewire
          libva
          openssl
        ]
      } \
      --add-needed "libpipewire-0.3.so.0" \
      --add-needed "libva.so.2" \
      --add-needed "libva-drm.so.2" \
      --add-needed "libva-x11.so.2" \
      --add-needed "libssl.so"
  '';

  cmakeFlags = [
    "-DENABLE_DYNAMIC_RESOLVE_VAAPI_SYMBOLS=0"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework AudioToolbox";
}
