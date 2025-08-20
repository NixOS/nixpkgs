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
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.14.3";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpebackend-fdo-${version}.tar.xz";
    sha256 = "sha256-EBIYQllahQKR2z6C89sLmYTfB5Ai04bOQsK4UIFZ3Gw=";
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
    libX11
  ];

  meta = with lib; {
    description = "Freedesktop.org backend for WPE WebKit";
    license = licenses.bsd2;
    homepage = "https://wpewebkit.org";
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.linux;
  };
}
