{ stdenv, lib, fetchgit, pkg-config, meson, ninja, scdoc
,freetype, fontconfig, pixman, tllist }:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.2.6";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fcft.git";
    rev = "${version}";
    sha256 = "06zywvvgrch9k4d07bir2sxddwsli2gzpvlvjfcwbrj3bw5x6j1b";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [ freetype fontconfig pixman tllist ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fcft";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with maintainers; [ fionera ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
