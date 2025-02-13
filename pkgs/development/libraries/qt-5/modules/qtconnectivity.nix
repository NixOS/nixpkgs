{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  bluez,
}:

qtModule {
  pname = "qtconnectivity";
  buildInputs = lib.optional stdenv.hostPlatform.isLinux bluez;
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
