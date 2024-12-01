{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  bluez,
  pkg-config,
}:

qtModule {
  pname = "qtconnectivity";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ bluez ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
}
