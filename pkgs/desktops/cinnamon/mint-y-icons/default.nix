{ fetchFromGitHub
, lib, stdenv
, gnome
, gnome-icon-theme
, hicolor-icon-theme
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "mint-y-icons";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # commit is named 1.4.3, tags=404
    rev = "c997af402d425889f2e4277966eebe473f7451f7";
    sha256 = "0yfas949xm85a28vgjqm9ym3bhhynrq256w9vfs8aiqq9nbm18mf";
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
