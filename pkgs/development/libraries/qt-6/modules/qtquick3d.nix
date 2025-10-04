{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtdeclarative,
  qtquick3d,
  openssl,
}:

qtModule {
  pname = "qtquick3d";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  # When cross building, qtquick3d depends on tools from the host version of itself
  propagatedNativeBuildInputs = lib.optional (
    !stdenv.buildPlatform.canExecute stdenv.hostPlatform
  ) qtquick3d;

  buildInputs = [ openssl ];
}
