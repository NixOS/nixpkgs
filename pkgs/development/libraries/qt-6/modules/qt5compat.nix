{
  qtModule,
  qtbase,
  qtdeclarative,
  libiconv,
  icu,
  openssl,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qt5compat";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [
    libiconv
    icu
    openssl
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];
}
