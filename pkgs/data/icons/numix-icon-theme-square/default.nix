{ lib, stdenvNoCC, fetchFromGitHub, gtk3, numix-icon-theme, hicolor-icon-theme, gitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme-square";
  version = "22.07.11";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZLQYS9KQETgjSSdwWiA2tiQGS5hiEt4Gl0hUw5RI/S0=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ numix-icon-theme hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -a Numix-Square{,-Light} $out/share/icons

    for panel in $out/share/icons/*/*/panel; do
      ln -sf $(realpath ${numix-icon-theme}/share/icons/Numix/16/$(readlink $panel)) $panel
    done

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater {inherit pname version; };

  meta = with lib; {
    description = "Numix icon theme (square version)";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
