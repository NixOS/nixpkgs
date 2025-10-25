{
  qtModule,
  qtbase,
  qtdeclarative,
  qtsvg,
  hunspell,
  pkg-config,
  lib,
  stdenv,
}:

qtModule {
  pname = "qtvirtualkeyboard";
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    hunspell
  ];
  nativeBuildInputs = [ pkg-config ];

  NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isLinux "-Wl,--build-id=none";
}
