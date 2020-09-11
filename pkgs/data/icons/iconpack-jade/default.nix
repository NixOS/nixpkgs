{ stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-jade";
  version = "1.23";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q29ikfssn1vmwws3dry4ssq6b44afd9sb7dwv3rdqg0frabpj1m";
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
