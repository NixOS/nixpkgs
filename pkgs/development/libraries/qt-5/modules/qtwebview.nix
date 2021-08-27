{ lib, stdenv, qtModule, qtdeclarative, qtwebengine, CoreFoundation, WebKit }:

qtModule {
  pname = "qtwebview";
  qtInputs = [ qtdeclarative qtwebengine ];
  buildInputs = lib.optional stdenv.isDarwin [
    CoreFoundation
    WebKit
  ];
  outputs = [ "out" "dev" "bin" ];
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreFoundation -framework WebKit";
}
