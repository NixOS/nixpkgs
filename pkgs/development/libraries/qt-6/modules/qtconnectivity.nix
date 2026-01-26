{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  bluez,
  pcsclite,
  pkg-config,
}:

qtModule {
  pname = "qtconnectivity";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pcsclite
    bluez
  ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}
