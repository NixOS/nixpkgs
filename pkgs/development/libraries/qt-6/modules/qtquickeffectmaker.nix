{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtquick3d,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtquickeffectmaker";
  propagatedBuildInputs = [
    qtbase
    qtquick3d
  ];

  # Still doesn't cross-compile, because it's blocked explicitly:
  # "Skipping the build as the condition "NOT CMAKE_CROSSCOMPILING" is not met."
  cmakeFlags = [
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];

  # Upstream explicitly skips the build when CMAKE_CROSSCOMPILING is set
  meta.broken = !lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform;
  meta.mainProgram = "qqem";
}
