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
  version = "1.12.3";

  src = fetchurl {
    url = "https://wpewebkit.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-uE/b+8hJzk/fCEuyi1jlRjsbS2zI8gDcd7QfhUXVMp0=";
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
