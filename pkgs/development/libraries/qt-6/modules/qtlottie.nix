{
  qtModule,
  qtbase,
  qtdeclarative,
  qtsvg,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtlottie";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
  ];

  # qtlottie uses qt_internal_add_qml_module(), which is available only when the
  # Qt Qml component is successfully found. In cross builds, Qt6Qml depends on
  # build-machine QmlTools and Qt6Quick depends on build-machine QuickTools.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    # qtlottie builds the host tool `lottietoqml` via qt_internal_find_tool(), which
    # locates it in the host-side Qt6LottieTools package.
    "-DQt6LottieTools_DIR=${pkgsBuildBuild.qt6.qtlottie}/lib/cmake/Qt6LottieTools"
  ];
}
