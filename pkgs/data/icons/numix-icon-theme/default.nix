{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "numix-icon-theme";
  version = "19.09.20";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "0pn3x0mmsph777lwhg890ck366p31bjl3755h4pv161ym08d4z9w";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -a Numix{,-Light} $out/share/icons/
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Numix icon theme";
    homepage = https://numixproject.github.io;
    license = licenses.gpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
