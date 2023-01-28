{ qtModule, speechd, pkg-config }:

qtModule {
  pname = "qtspeech";
  qtInputs = [ ];
  buildInputs = [ speechd ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" ];
}
