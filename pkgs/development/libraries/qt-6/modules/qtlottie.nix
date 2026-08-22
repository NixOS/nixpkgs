{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtlottie";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  # Conditional is required to prevent infinite recursion during a cross build
  cmakeFlags =
    lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DQt6LottieTools_DIR=${pkgsBuildBuild.qt6.qtlottie}/lib/cmake/Qt6LottieTools"
    ]
    ++ [
      "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
      "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    ];
}
