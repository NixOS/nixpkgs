{
  lib,
  stdenv,
  qtModule,
  qtdeclarative,
  qtwebengine,
}:

qtModule {
  pname = "qtwebview";
  propagatedBuildInputs = [
    qtdeclarative
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ qtwebengine ];
}
