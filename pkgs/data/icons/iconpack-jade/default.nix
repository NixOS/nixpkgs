{ stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-jade";
  version = "1.24";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bns1f3vv7d7ps08plnhl3432cy2l2mhv85h7n4fifjqqi8bll9x";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Jade* $out/share/icons

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Icon pack based upon Faenza and Mint-X";
    homepage = "https://github.com/madmaxms/iconpack-jade";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
