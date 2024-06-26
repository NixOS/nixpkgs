{
  lib,
  stdenv,
  qtModule,
  qtdeclarative,
  qtwebengine,
  CoreFoundation,
  WebKit,
}:

qtModule {
  pname = "qtwebview";
  propagatedBuildInputs = [
    qtdeclarative
    qtwebengine
  ];
  buildInputs = lib.optionals stdenv.isDarwin [
    CoreFoundation
    WebKit
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-framework CoreFoundation -framework WebKit";
}
