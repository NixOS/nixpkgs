{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtdeclarative,
  qtremoteobjects,
}:

qtModule {
  pname = "qtremoteobjects";

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  # When cross building, qtremoteobjects depends on tools from the host version of itself
  propagatedNativeBuildInputs = lib.optional (
    !stdenv.buildPlatform.canExecute stdenv.hostPlatform
  ) qtremoteobjects;
}
