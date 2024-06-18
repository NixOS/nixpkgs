{ fetchFromGitHub
, lib
, stdenvNoCC
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
, humanity-icon-theme
, ubuntu-themes
}:

stdenvNoCC.mkDerivation rec {
  pname = "mint-x-icons";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-J5Osy+VosyBhwiiwELMtjDTf3/J6DpuQ4c9DO06fo+4=";
  };

  propagatedBuildInputs = [
    gnome.adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
    humanity-icon-theme
    ubuntu-themes # provides ubuntu-mono-dark
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
    homepage = "https://github.com/linuxmint/mint-x-icons";
    description = "Mint/metal theme based on mintified versions of Clearlooks Revamp, Elementary and Faenza";
    license = licenses.gpl3Plus; # from debian/copyright
    platforms = platforms.linux;
    maintainers = teams.cinnamon.members;
  };
}
