{ stdenv
, lib
, fetchurl
, meson
, pkg-config
, ninja
, wayland
, epoxy
, glib
, libwpe
, libxkbcommon
, libGL
, libX11 }:

stdenv.mkDerivation rec {
  pname = "wpebackend-fdo";
  version = "1.8.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-llKpnHX+HG6rBYW2OV9OEEskJ+TR9Clp8fd98pkg0lM=";
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
    epoxy
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
