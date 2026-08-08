{
  pkgsBuildBuild,
  stdenv,
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  libdrm,
}:

qtModule {
  pname = "qtwayland";

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [ libdrm ];

  # Conditional is required to prevent infinite recursion during a cross build
  cmakeFlags =
    lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6WaylandScannerTools_DIR=${pkgsBuildBuild.qt6.qtbase}/lib/cmake/Qt6WaylandScannerTools"
    ]
    ++ [
      "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
