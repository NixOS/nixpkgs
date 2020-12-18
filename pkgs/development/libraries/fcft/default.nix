{ stdenv, lib, fetchgit, pkg-config, meson, ninja, scdoc
,freetype, fontconfig, harfbuzz, pixman, tllist, check }:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.3.2";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fcft.git";
    rev = version;
    sha256 = "0k2i57rakm4g86f7hbhkby8af0vv7v63a70lk3m58mkycpy5q2rm";
  };

  nativeBuildInputs = [ pkg-config meson ninja scdoc ];
  buildInputs = [ freetype fontconfig pixman tllist harfbuzz ];
  checkInputs = [ check ];

  mesonFlags = [ "--buildtype=release" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://codeberg.org/dnkl/fcft";
    description = "Simple library for font loading and glyph rasterization";
    maintainers = with maintainers; [ fionera ];
    license = licenses.mit;
    platforms = with platforms; linux;
  };
}
