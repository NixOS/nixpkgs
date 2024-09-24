{ qtModule
, lib
, stdenv
, qtbase
, qtdeclarative
, qtquick3d
, qtshadertools
, qtsvg
, pkg-config
, alsa-lib
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-libav
, gst-vaapi
, ffmpeg_7
, libva
, libpulseaudio
, wayland
, libXrandr
, elfutils
, libunwind
, orc
, VideoToolbox
, pkgsBuildBuild
}:

qtModule {
  pname = "qtmultimedia";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ffmpeg_7 ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [ libunwind orc ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ libpulseaudio alsa-lib wayland libXrandr libva ]
    ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [ elfutils ];
  propagatedBuildInputs = [ qtbase qtdeclarative qtsvg qtshadertools ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW) [ qtquick3d ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ VideoToolbox ];

  patches = [
    ../patches/fix-qtgui-include-incorrect-case.patch
    # Remove new constants since macOS 12+, since we build Qt with the macOS 11 SDK
    ../patches/qtmultimedia-darwin-revert-replace-deprecated-constant.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    ../patches/qtmultimedia-windows-no-uppercase-libs.patch
    ../patches/qtmultimedia-windows-resolve-function-name.patch
  ];

  cmakeFlags = [
    "-DENABLE_DYNAMIC_RESOLVE_VAAPI_SYMBOLS=0"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin
    "-include AudioToolbox/AudioToolbox.h";
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin
    "-framework AudioToolbox";
}
