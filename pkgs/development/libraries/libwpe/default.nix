{ stdenv
, lib
, fetchurl
, meson
, pkg-config
, libxkbcommon
, libGL
, ninja
, libX11
, webkitgtk
}:

stdenv.mkDerivation rec {
  pname = "libwpe";
  version = "1.14.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/libwpe-${version}.tar.xz";
    sha256 = "sha256-sdDNzw+Nu0lOZbD3kT41cQbamg1X9Pu3udEjim2+mt4=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libxkbcommon
    libGL
    libX11
  ];

  meta = with lib; {
    description = "General-purpose library for WPE WebKit";
    license = licenses.bsd2;
    homepage = "https://wpewebkit.org";
    maintainers = webkitgtk.meta.maintainers ++ (with maintainers; [ matthewbauer ]);
    platforms = platforms.linux;
  };
}
