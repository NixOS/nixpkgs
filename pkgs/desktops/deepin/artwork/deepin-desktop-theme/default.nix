{ stdenv
, lib
, fetchFromGitHub
, cmake
, gtk3
, xcursorgen
, papirus-icon-theme
, breeze-icons
, hicolor-icon-theme
, deepin-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "deepin-desktop-theme";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-rhbxqKT9yrtW4JJ8jCUSpsIh0JeEIttkS414vBhD9vs=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [
    cmake
    gtk3
    xcursorgen
  ];

  propagatedBuildInputs = [
    breeze-icons
    papirus-icon-theme
    hicolor-icon-theme
    deepin-icon-theme
  ];

  dontDropIconThemeCache = true;

  preFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Provides a variety of well-designed theme resources";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-theme";
    license = with licenses; [ gpl3Plus cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
