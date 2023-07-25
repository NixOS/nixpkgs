{ stdenvNoCC
, lib
, fetchFromGitHub
, gtk3
, xcursorgen
, papirus-icon-theme
}:

stdenvNoCC.mkDerivation rec {
  pname = "deepin-icon-theme";
  version = "2021.11.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-UC3PbqolcCbVrIEDqMovfJ4oeofMUGJag1A6u7X3Ml8=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [
    gtk3
    xcursorgen
  ];

  propagatedBuildInputs = [
    papirus-icon-theme
  ];

  dontDropIconThemeCache = true;

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Deepin Icon Theme provides the base icon themes on Deepin";
    homepage = "https://github.com/linuxdeepin/deepin-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
