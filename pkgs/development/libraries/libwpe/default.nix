{ stdenv
, lib
, fetchurl
, meson
, pkg-config
, libxkbcommon
, libGL
, ninja
, libX11 }:

stdenv.mkDerivation rec {
  pname = "libwpe";
  version = "1.7.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0h6kh8wy2b370y705pl2vp6vp18dkdsgdxh0243ji2v51kxbg157";
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
    maintainers = with maintainers; [ matthewbauer ];
    platforms = platforms.linux;
  };
}
