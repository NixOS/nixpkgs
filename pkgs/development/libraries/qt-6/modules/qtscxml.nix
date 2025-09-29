{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtdeclarative,
  qtscxml,
}:

qtModule {
  pname = "qtscxml";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  # When cross building, qtscxml depends on tools from the host version of itself
  propagatedNativeBuildInputs = lib.optional (
    !stdenv.buildPlatform.canExecute stdenv.hostPlatform
  ) qtscxml;
}
