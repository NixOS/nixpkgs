{
  lib,
  stdenv,
  qtModule,
  qtdeclarative,
  qtwebengine,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtwebview";
  propagatedBuildInputs = [
    qtdeclarative
  ]
  # qtwebengine isn't available on MinGW hostPlatform in nixpkgs. MSYS2's qt6-webview
  # also doesn't depend on qt6-webengine. Keep WebEngine only where it is supported.
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform qtwebengine) [ qtwebengine ];

  # Cross: webview contains a QtQuick QML module (uses qt_internal_add_qml_module).
  # Ensure Qt6Qml/Qt6Quick are "FOUND" by providing the build-machine tool packages.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
