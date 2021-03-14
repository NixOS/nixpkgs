{ lib, stdenv, fetchFromGitHub , gtk3, breeze-icons, gnome-icon-theme, hicolor-icon-theme }:

stdenv.mkDerivation rec  {
  pname = "kora-icon-theme";
  version = "1.4.1";

  src = fetchFromGitHub  {
    owner = "bikass";
    repo = "kora";
    rev = "v${version}";
    sha256 = "sha256-YGhusal8g/UXMqrQvj147OScg51uNABTMIXxVXvnpKY=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv kora* $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "An SVG icon theme in four variants";
    homepage = "https://github.com/bikass/kora";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ bloomvdomino ];
  };
}
