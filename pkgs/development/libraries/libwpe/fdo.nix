{
  stdenv,
  lib,
  fetchurl,
  meson,
  pkg-config,
  ninja,
  wayland-scanner,
  wayland,
  libepoxy,
  glib,
  libwpe,
  libxkbcommon,
  libGL,
  libx11,
}:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.16.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpebackend-fdo-${version}.tar.xz";
    sha256 = "sha256-VErhQBL45+QmuMtSLrCqqsgxrXw1YB0c8x03Zw4Ouzs=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland-scanner
  ];

  buildInputs = [
    wayland
    libepoxy
    glib
    libwpe
    libxkbcommon
    libGL
    libx11
  ];

  meta = {
    description = "Freedesktop.org backend for WPE WebKit";
    license = lib.licenses.bsd2;
    homepage = "https://wpewebkit.org";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
