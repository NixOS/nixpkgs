{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  bluez,
  pcsclite,
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
}
