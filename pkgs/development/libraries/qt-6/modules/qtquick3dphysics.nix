{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtquick3d,
  qtshadertools,
  pkgsBuildBuild,
  qtdeclarative,
}:

qtModule {
  pname = "qtquick3dphysics";
  propagatedBuildInputs = [
    qtbase
    qtquick3d
    qtshadertools
  ];

  postPatch = ''
    # Windows includes are case-insensitive; cross builds on Linux are not.
    # PhysX uses <Winsock2.h> but MinGW headers provide <winsock2.h>.
    substituteInPlace src/3rdparty/PhysX/source/foundation/src/windows/PsWindowsSocket.cpp \
      --replace-fail '<Winsock2.h>' '<winsock2.h>'
  '';

  cmakeFlags = [
    "-DQt6Quick3D_DIR=${qtquick3d.dev}/lib/cmake/Qt6Quick3D"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6Quick3DTools_DIR=${pkgsBuildBuild.qt6.qtquick3d}/lib/cmake/Qt6Quick3DTools"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];

  meta.mainProgram = "cooker";
}
