{ lib
, stdenv
, qtModule
, qtdeclarative
, qtwebengine
}:

qtModule {
  pname = "qtwebview";
  qtInputs = [ qtdeclarative qtwebengine ];
}
