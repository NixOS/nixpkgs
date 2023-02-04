{ lib
, stdenv
, qtModule
, qtdeclarative
, qtwebengine
, WebKit
}:

qtModule {
  pname = "qtwebview";
  qtInputs = [ qtdeclarative ]
    ++ lib.optionals (!stdenv.isDarwin) [ qtwebengine ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ WebKit ];
}
