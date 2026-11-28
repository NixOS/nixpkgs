{
  qtModule,
  qtbase,
  qtdeclarative,
  qtwebsockets,
  openssl,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtwebsockets
  ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
