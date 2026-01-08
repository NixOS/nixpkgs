{
  qtModule,
  qtbase,
  qtdeclarative,
  qtshadertools,
  openssl,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtquick3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtshadertools
  ];
  buildInputs = [ openssl ];

  # QtQuick component discovery expects Qt6Quick to be findable, and Qt6Quick depends on
  # the build-machine Qt6QuickTools package in cross builds.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    # Needed for cross builds: provides `Qt6::qsb` host tool used by QtQuick3D.
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    # Needed for cross builds: provides the host tool `Qt6::balsam` from Qt6Quick3DTools.
    "-DQt6Quick3DTools_DIR=${pkgsBuildBuild.qt6.qtquick3d}/lib/cmake/Qt6Quick3DTools"
  ];
}
