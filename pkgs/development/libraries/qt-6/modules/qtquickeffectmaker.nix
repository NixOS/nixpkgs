{
  qtModule,
  lib,
  pkgsBuildBuild,
  stdenv,
  qtbase,
  qtdeclarative,
  qtquick3d,
  qtshadertools,
}:

qtModule {
  pname = "qtquickeffectmaker";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtquick3d
    qtshadertools
  ];

  postPatch =
    # For the MinGW cross use-case we do not need to execute target binaries during the build
    lib.optionalString
      (!stdenv.buildPlatform.canExecute stdenv.hostPlatform && stdenv.hostPlatform.isMinGW)
      ''
        substituteInPlace CMakeLists.txt \
          --replace-fail 'if(CMAKE_CROSSCOMPILING)' 'if(FALSE)'
      ''
    # Windows headers are case-insensitive; cross builds on Linux are not.
    # MinGW provides <windows.h>, but upstream includes <Windows.h>.
    + lib.optionalString stdenv.hostPlatform.isMinGW ''
      substituteInPlace tools/qqem/main.cpp \
        --replace-fail '<Windows.h>' '<windows.h>'
    '';

  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];

  meta.mainProgram = "qqem";
}
