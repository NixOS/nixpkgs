{ lib, stdenvNoCC, fetchFromGitHub, gtk3, breeze-icons, pantheon, gnome-icon-theme, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec  {
  pname = "flat-remix-icon-theme";
  version = "20220525";

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = "flat-remix";
    rev = version;
    sha256 = "sha256-JpUa2nxZxrLTd80qdiGpob4Trq41ONthsPA4zFj/6nk=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    pantheon.elementary-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    mv Flat-Remix* $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "Flat remix is a pretty simple icon theme inspired on material design";
    homepage = "https://drasite.com/flat-remix";
    license = with licenses; [ gpl3Only ];
    # breeze-icons and pantheon.elementary-icon-theme dependencies are restricted to linux
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
