{ lib, qtModule, stdenv, speechd, pkg-config }:

qtModule {
  pname = "qtspeech";
  qtInputs = [ ];
  buildInputs = lib.optionals stdenv.isLinux [ speechd ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [ "out" "dev" ];
}
