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
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ qtwebengine ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ WebKit ];
}
