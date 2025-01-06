{
  stdenv,
  lib,
  fetchurl,
  meson,
  pkg-config,
  libxkbcommon,
  libGL,
  ninja,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "libwpe";
  version = "1.16.0";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/libwpe-${version}.tar.xz";
    sha256 = "sha256-x/OjxrPQBnkNSG3HzO2ittLjKd4H8zvEffxT8A8zSyo=";
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

  meta = {
    description = "General-purpose library for WPE WebKit";
    license = lib.licenses.bsd2;
    homepage = "https://wpewebkit.org";
    maintainers = with lib.maintainers; [ matthewbauer ];
    platforms = lib.platforms.linux;
  };
}
