{
  pkgsBuildBuild,
  stdenv,
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  wayland,
  wayland-scanner,
  pkg-config,
  libdrm,
}:

qtModule {
  pname = "qtwayland";

  # wayland-scanner needs to be propagated as both build
  # (for the wayland-scanner binary) and host (for the
  # actual wayland.xml protocol definition)
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    wayland
    wayland-scanner
  ];
  propagatedNativeBuildInputs = [
    wayland
    wayland-scanner
  ];
  buildInputs = [ libdrm ];
  nativeBuildInputs = [ pkg-config ];

  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6WaylandScannerTools_DIR=${pkgsBuildBuild.qt6.qtwayland}/lib/cmake/Qt6WaylandScannerTools"
  ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
