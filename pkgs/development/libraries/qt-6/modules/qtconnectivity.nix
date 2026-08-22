{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  bluez,
  pcsclite,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtconnectivity";
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pcsclite
    bluez
  ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  cmakeFlags = [
    "-DQt6QuickTools_DIR=${pkgsBuildBuild.qt6.qtdeclarative}/lib/cmake/Qt6QuickTools"
  ];
}
