{ fetchFromGitHub
, lib
, stdenv
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "mint-y-icons";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # they don't exactly do tags, it's just a named commit
    rev = "57d16eb85f2af40be17e2232d279bb65b689f5b7";
    hash = "sha256-voFYz0MiuqyNSngi4QZUJKDIjggQWOAV5B30zMP8iTk=";
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
