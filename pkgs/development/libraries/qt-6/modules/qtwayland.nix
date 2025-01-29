{
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  wayland,
  wayland-scanner,
  pkg-config,
  libdrm,
  fetchpatch2,
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

  patches = [
    # backport fix for crashes when hotplugging a graphics tablet, as recommended by upstream
    # FIXME: remove in 6.8.2
    (fetchpatch2 {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/24002ac6cbd01dbde4944b63c1f7c87ed2bd72b5.patch";
      hash = "sha256-Lz4Gv6FLhFGv7dVpqqcss6/w5jsGA8SKaNeWMHT0A/A=";
    })

    # run waylandscanner with private-code to avoid conflict with symbols from libwayland
    # better solution for https://github.com/NixOS/nixpkgs/pull/337913
    (fetchpatch2 {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/67f121cc4c3865aa3a93cf563caa1d9da3c92695.patch";
      hash = "sha256-uh5lecHlHCWyO1/EU5kQ00VS7eti3PEvPA2HBCL9K0k=";
    })

    # fix crash when attach differ shellsurface to the same shellsurfaceitem
    (fetchpatch2 {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/070414dd4155e13583e5e8b16bed1a5b68d32910.patch";
      hash = "sha256-JLTdSEbqM6OSijk0cgC419AdLE+PF5KbFh3ypgYUKz8=";
    })
  ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
