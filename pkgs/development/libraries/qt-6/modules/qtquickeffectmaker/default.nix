{
  lib,
  stdenv,
  qtModule,
  qtbase,
  qtquick3d,
}:

qtModule {
  pname = "qtquickeffectmaker";
  propagatedBuildInputs = [
    qtbase
    qtquick3d
  ];

  patches = lib.optional (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ./cross-compile.patch;

  meta.mainProgram = "qqem";
}
