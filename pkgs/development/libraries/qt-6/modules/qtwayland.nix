{
  pkgsBuildBuild,
  stdenv,
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  pkg-config,
  libdrm,
}:

qtModule {
  pname = "qtwayland";

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [ libdrm ];
  nativeBuildInputs = [ pkg-config ];

  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6WaylandScannerTools_DIR=${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6WaylandScannerTools"
  ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
