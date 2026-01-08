{
  qtModule,
  qtbase,
  qtdeclarative,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtdatavis3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  # Qt6 component discovery expects Qt6<Module> packages to be available.
  # In our split-prefix Qt packaging this needs a bit of help, especially for
  # cross builds where QmlTools must come from the build machine.
  #
  # MSYS2 reference: mingw-w64-qt6-datavis3d depends on qt6-declarative.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    # Qt6Quick depends on the (host) Qt6QuickTools package when cross-compiling.
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
