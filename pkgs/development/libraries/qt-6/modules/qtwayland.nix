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
  ];

  # Replace vendored wayland.xml with our matching version
  # FIXME: remove when upstream updates past 1.23
  postPatch = ''
    cp ${wayland-scanner}/share/wayland/wayland.xml src/3rdparty/protocol/wayland/wayland.xml
  '';

  meta = {
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
  };
}
