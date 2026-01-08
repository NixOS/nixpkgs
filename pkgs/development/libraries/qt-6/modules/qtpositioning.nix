{
  qtModule,
  qtbase,
  qtdeclarative,
  qtserialport,
  pkg-config,
  openssl,
  qtsvg,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtpositioning";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtserialport
    qtsvg
  ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
