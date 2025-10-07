{
  stdenv,
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  qtwayland,
  wayland,
  wayland-scanner,
  pkg-config,
  libdrm,
}:

qtModule {
  pname = "qtwayland";

  # wayland-scanner needs to be propagated as both build
  # (for the wayland-scanner binary) and host (for the
  # actual wayland.xml protocol definition)
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    wayland
    wayland-scanner
  ];
  propagatedNativeBuildInputs = [
    wayland
    wayland-scanner
  ]
  # When cross building, qtwayland depends on tools from the host version of itself
  ++ lib.optional (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) qtwayland;
  buildInputs = [ libdrm ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
