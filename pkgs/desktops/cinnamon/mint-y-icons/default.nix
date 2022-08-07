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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    # they don't exactly do tags, it's just a named commit
    rev = "6294c4538a08a2a6c5fd68e223472d9c144ff8b0";
    hash = "sha256-6tR3OFvU1ID61n4gr0R6pJyo3CjKvu8mgtXzMOINgq0=";
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
