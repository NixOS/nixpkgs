{
  qtModule,
  qtbase,
  qtshadertools,
  stdenv,
  lib,
}:

qtModule {
  pname = "qtshadertools";
  propagatedBuildInputs = [ qtbase ];
  # When cross building, qtshadertools depends on tools from the host version of itself
  propagatedNativeBuildInputs = lib.optional (
    !stdenv.buildPlatform.canExecute stdenv.hostPlatform
  ) qtshadertools;
  meta.mainProgram = "qsb";
}
