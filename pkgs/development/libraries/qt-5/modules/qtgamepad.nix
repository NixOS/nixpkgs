{ qtModule, qtbase, qtdeclarative, pkg-config }:

qtModule {
  pname = "qtgamepad";
  qtInputs = [ qtbase qtdeclarative ];
  buildInputs = [ ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" "bin" ];
}
