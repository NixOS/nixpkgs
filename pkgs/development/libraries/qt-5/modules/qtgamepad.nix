{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtdeclarative,
  GameController,
  pkg-config,
}:

qtModule {
  pname = "qtgamepad";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ] ++ lib.optional stdenv.isDarwin GameController;
  buildInputs = [ ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
}
