{ stdenv, lib, fetchgit, pkg-config, meson, ninja, scdoc
,freetype, fontconfig, pixman, tllist, check, harfbuzz
}:

stdenv.mkDerivation rec {
  pname = "fcft";
  version = "2.3.1";

  src = fetchgit {
    url = "https://codeberg.org/dnkl/fcft.git";
    rev = version;
    sha256 = "1ddzdfq6y9db50zimxfsr955zkpr8y6fk4nrblsl0j0vliywlg8l";
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
    changelog = "https://codeberg.org/dnkl/fcft/releases/tag/${version}";
  };
}
