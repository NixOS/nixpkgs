{
  qtModule,
  qtbase,
  qtdeclarative,
  qtsvg,
  hunspell,
  pkg-config,
  fetchpatch,
  lib,
  pkgsBuildBuild,
  stdenv,
}:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    hunspell
  ];
  nativeBuildInputs = [ pkg-config ];
  patches = [
    # https://qt-project.atlassian.net/browse/QTBUG-137440
    (fetchpatch {
      name = "rb-link-core-into-styles.patch";
      url = "https://github.com/qt/qtvirtualkeyboard/commit/0b1e8be8dd874e1fbacd0c30ed5be7342f6cd44d.patch";
      hash = "sha256-Uk6EJOlkCRLUg1w3ljHaxV/dXEVWyUpP/ijoyjptbNc=";
    })
  ];

  # Cross: QtVirtualKeyboard is a QtQuick module; ensure Qt::Quick is discoverable
  # and that host-side Qml/Quick tools are available.
  cmakeFlags = [
    "-DQt6Quick_DIR=${qtdeclarative}/lib/cmake/Qt6Quick"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6QmlTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QmlTools"
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
