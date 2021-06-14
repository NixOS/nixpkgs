{ darwin, lib, stdenv, qtModule, qtdeclarative, qtwebengine }:

with lib;

qtModule {
  pname = "qtwebview";
  qtInputs = [ qtdeclarative qtwebengine ];
  buildInputs = optional (stdenv.isDarwin) [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.WebKit
  ];
  outputs = [ "out" "dev" "bin" ];
  NIX_LDFLAGS = optionalString stdenv.isDarwin "-framework CoreFoundation -framework WebKit";
}
