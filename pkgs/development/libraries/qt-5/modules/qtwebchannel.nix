{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtdeclarative,
}:

qtModule {
  pname = "qtwebchannel";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];
  outputs = [
    "out"
    "dev"
  ] ++ lib.optionals (stdenv.hostPlatform.equals stdenv.buildPlatform) [ "bin" ];
}
