{
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
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
  ];
  buildInputs = [ libdrm ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
