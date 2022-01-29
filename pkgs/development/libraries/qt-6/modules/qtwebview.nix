{ lib
, stdenv
, qtModule
, qtdeclarative
, qtwebengine
, CoreFoundation
, WebKit

  /*
    # FIXME these should be propagated by qtwebengine
    , qtwebchannel
    , qtwebsockets
    , qtpositioning
  */
}:

qtModule {
  pname = "qtwebview";
  qtInputs = [ qtdeclarative qtwebengine /*qtwebchannel qtwebsockets qtpositioning*/ ];
  buildInputs = lib.optionals stdenv.isDarwin [ CoreFoundation WebKit ];
  outputs = [ "out" "dev" "bin" ];
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreFoundation -framework WebKit";
}
