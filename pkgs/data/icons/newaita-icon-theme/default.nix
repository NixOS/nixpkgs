{ lib, stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation {
  pname = "newaita-icon-theme";
  version = "unstable-2021-07-22";

  src = fetchFromGitHub {
    owner = "cbrnix";
    repo = "Newaita";
    rev = "c2b596b097a83be23833dc7bc40b5d07a63315e3";
    sha256 = "sha256-tqtjUy8RjvOu0NaK+iE0R1g7/eqCpmhbdxuNGd/YfSI=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Newaita* $out/share/icons
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "A icon theme combining old style and color of material design";
    homepage = "https://github.com/cbrnix/Newaita";
    license = licenses.cc-by-nc-sa-30;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
