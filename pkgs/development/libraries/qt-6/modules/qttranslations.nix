{
  qtModule,
  lib,
  stdenv,
  python3,
  qttools,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qttranslations";
  nativeBuildInputs = [
    qttools
    python3
  ];
  separateDebugInfo = false;
  outputs = [ "out" ];
  allowedReferences = [ "out" ];

  # Conditional is required to prevent infinite recursion during a cross build
  cmakeFlags = lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DQt6LinguistTools_DIR=${pkgsBuildBuild.qt6.qttools}/lib/cmake/Qt6LinguistTools"
  ];
}
