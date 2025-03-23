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
    qtwebengine
  ];
  outputs = [
    "out"
    "dev"
    "bin"
  ];
  NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-framework CoreFoundation -framework WebKit";
}
