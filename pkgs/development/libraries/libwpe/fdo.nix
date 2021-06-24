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
  version = "1.7.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1xf6akagvpyh0nyxkfijrx5avp6ravnivy28dhk64dsfx9rhm64v";
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
