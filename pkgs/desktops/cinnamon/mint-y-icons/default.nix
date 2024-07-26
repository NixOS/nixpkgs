{ fetchFromGitHub
, lib
, stdenvNoCC
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-y-icons";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-8dwJyvM5sQNtUzhreBCgSWeElGlp/z3Dk7/xCeUSGKU=";
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
    homepage = "https://github.com/linuxmint/mint-y-icons";
    description = "The Mint-Y icon theme";
    license = licenses.gpl3; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
