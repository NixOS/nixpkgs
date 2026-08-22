{
  qtModule,
  qtbase,
  qtdeclarative,
  openssl,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtwebsockets";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
