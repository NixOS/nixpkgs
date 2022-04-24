{ stdenv
, lib
, fetchurl
, meson
, pkg-config
, ninja
, wayland
, libepoxy
, glib
, libwpe
, libxkbcommon
, libGL
, libX11 }:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.12.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-YjnJwVUjQQeY1mMV3mtJFxKrMACboYDz4N0HbZsAdKw=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    wayland
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
