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
  version = "1.10.1";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-oyez/88jVtvoFIwdtLvcU1nX5xY9F39nVRqDk7FErfA=";
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
