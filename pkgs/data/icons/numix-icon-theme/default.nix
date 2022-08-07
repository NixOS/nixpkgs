{ lib, stdenvNoCC, fetchFromGitHub, gtk3, gnome-icon-theme, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme";
  version = "21.10.31";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "sha256-wyVvXifdbKR2aiBMrki8y/H0khH4eFD1RHVSC+jAT28=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gnome-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Numix{,-Light} $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Numix icon theme";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
