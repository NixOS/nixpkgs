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
, libX11
, webkitgtk
 }:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.12.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-RaqDPETsKS8x+pQ7AbjMdeVOtiOte6amb8LxGP5p5ik=";
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
    maintainers = webkitgtk.meta.maintainers ++ (with maintainers; [ matthewbauer ]);
    platforms = platforms.linux;
  };
}
