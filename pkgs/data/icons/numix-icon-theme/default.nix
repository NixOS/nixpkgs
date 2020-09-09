{ stdenv, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme";
  version = "20.06.07";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "1yp9parc8ihmai8pswf4qzrqd88qpls87ipq8ylx38yqns7wsn4h";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Numix{,-Light} $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
