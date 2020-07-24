{ stdenv, lib, fetchgit, pkg-config, meson, ninja, freetype, fontconfig, pixman, tllist }:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "0.4.3";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fcft.git";
    rev = "${version}";
    sha256 = "1r2k5726k6ps8ml2s1vqmpiggqxzq9pbzs7m0dsxk29mh8vg0psj";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ freetype fontconfig pixman tllist ];

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fcft";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with maintainers; [ fionera ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
