{ lib, stdenv, qtModule, qtdeclarative, qtwebengine, CoreFoundation, WebKit }:

qtModule {
  pname = "qtwebview";
  propagatedBuildInputs = [ qtdeclarative qtwebengine ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    WebKit
  ];
  outputs = [ "out" "dev" "bin" ];
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework CoreFoundation -framework WebKit";
}
