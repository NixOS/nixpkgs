{ lib
, stdenv
, qtModule
, qtdeclarative
, qtwebengine
, WebKit
}:

qtModule {
  pname = "qtwebview";
  propagatedBuildInputs = [ qtdeclarative ]
    ++ lib.optionals (!stdenv.isDarwin) [ qtwebengine ]
    ++ lib.optionals stdenv.isDarwin [ WebKit ];
}
