{
  qtModule,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtsvg,
  hunspell,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtmultimedia
    qtsvg
    hunspell
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
