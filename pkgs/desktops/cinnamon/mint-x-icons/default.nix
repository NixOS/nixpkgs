{ fetchFromGitHub
, lib
, stdenv
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
, humanity-icon-theme
, ubuntu-themes
}:

stdenv.mkDerivation rec {
  pname = "mint-x-icons";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # they don't exactly do tags, it's just a named commit
    rev = "286eb4acdfc3e3c77572dfd0cd70ffd4208d3a35";
    hash = "sha256-mZkCEBC1O2mW8rM1kpOWdC5CwIeafyBS95cMY6x1yco=";
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
