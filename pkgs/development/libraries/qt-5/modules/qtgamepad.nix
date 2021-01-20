{ qtModule, qtbase, qtdeclarative, pkg-config }:

qtModule {
  name = "qtgamepad";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}
