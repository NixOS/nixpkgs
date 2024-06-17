{ stdenvNoCC
, lib
, fetchFromGitHub
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-l-icons";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-Uzayo1hmNwOMszTV8/KqOLxjERBC/L16hRpCWbK10Uc=";
  };

  propagatedBuildInputs = [
    gnome.adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  nativeBuildInputs = [
    gtk3
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv usr/share $out

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxmint/mint-l-icons";
    description = "Mint-L icon theme";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
