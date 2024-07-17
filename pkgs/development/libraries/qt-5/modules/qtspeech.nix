{
  lib,
  qtModule,
  stdenv,
  speechd,
  pkg-config,
}:

qtModule {
  pname = "qtspeech";
  propagatedBuildInputs = [ ];
  buildInputs = lib.optionals stdenv.isLinux [ speechd ];
  nativeBuildInputs = [ pkg-config ];
  outputs = [
    "out"
    "dev"
  ];
}
