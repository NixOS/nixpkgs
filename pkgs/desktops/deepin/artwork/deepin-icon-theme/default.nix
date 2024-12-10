{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gtk3,
  xcursorgen,
  papirus-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "deepin-icon-theme";
  version = "2024.01.31";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-08maujG5Tibsv9N+5olOeD8MrXTRiZh0OQm0bg8t+Cc=";
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

  preFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Provides the base icon themes on deepin";
    homepage = "https://github.com/linuxdeepin/deepin-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
