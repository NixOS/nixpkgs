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
    # run waylandscanner with private-code to avoid conflict with symbols from libwayland
    # better solution for https://github.com/NixOS/nixpkgs/pull/337913
    (fetchpatch2 {
      url = "https://invent.kde.org/qt/qt/qtwayland/-/commit/67f121cc4c3865aa3a93cf563caa1d9da3c92695.patch";
      hash = "sha256-uh5lecHlHCWyO1/EU5kQ00VS7eti3PEvPA2HBCL9K0k=";
    })
  ];

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
