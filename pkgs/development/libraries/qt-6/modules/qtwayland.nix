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
  fetchpatch,
}:

qtModule {
  pname = "qtwayland";

  # Backport fix for popups not rendering properly
  # FIXME: remove in 6.9.1
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/e4556c59f0c8250da7c16759432b2ac0a5ac9d9f.patch";
      hash = "sha256-wRNXBwecuULn5MD87HP20uSuxHiuQslKp20DIuCGheM=";
    })
  ];

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
