{ lib, stdenv, qtModule, qtbase, qtdeclarative, GameController, pkg-config }:

qtModule {
  pname = "qtgamepad";
  propagatedBuildInputs = [ qtbase qtdeclarative ]
    ++ lib.optional stdenv.hostPlatform.isDarwin GameController;
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}
