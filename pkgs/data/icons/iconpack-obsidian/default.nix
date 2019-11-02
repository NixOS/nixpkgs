{ stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "iconpack-obsidian";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "madmaxms";
    repo = "iconpack-obsidian";
    rev = "v${version}";
    sha256 = "169inxprlwmhzlhknjgpraqdpwv2wi99rakqi5yhhqnqgyf4m4y3";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
     mkdir -p $out/share/icons
     mv Obsidian* $out/share/icons
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnome Icon Pack based upon Faenza";
    homepage = https://github.com/madmaxms/iconpack-obsidian;
    license = licenses.lgpl3;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
