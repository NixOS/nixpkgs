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
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-framework CoreFoundation -framework WebKit";
  };
}
