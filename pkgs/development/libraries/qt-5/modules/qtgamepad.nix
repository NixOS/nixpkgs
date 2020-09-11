{ qtModule, qtbase, qtdeclarative, pkgconfig }:

qtModule {
  name = "qtgamepad";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ ];
  nativeBuildInputs = [ pkgconfig ];
  outputs = [ "out" "dev" "bin" ];
}
