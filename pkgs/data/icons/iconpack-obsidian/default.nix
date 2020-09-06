{ stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, mint-x-icons, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-obsidian";
  version = "4.13";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hh0hnd2d08l4n5r73fkngv08f8230pp94k9qq8xgmchvjfg6j8y";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme mint-x-icons hicolor-icon-theme ];
  # still missing parent themes: Ambiant-MATE, Faenza-Dark, KFaenza

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Obsidian* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnome icon pack based upon Faenza";
    homepage = "https://github.com/madmaxms/iconpack-obsidian";
    license = licenses.lgpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
