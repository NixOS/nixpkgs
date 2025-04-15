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
  version = "1.16.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/wpebackend-fdo-${version}.tar.xz";
    sha256 = "sha256-vt3zISMtW9CBBsF528YA+M6I6zYgtKWaYykGO3j2RjU=";
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
