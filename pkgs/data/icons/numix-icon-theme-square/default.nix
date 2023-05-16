{ lib, stdenvNoCC, fetchFromGitHub, gtk3, numix-icon-theme, hicolor-icon-theme, gitUpdater }:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme-square";
<<<<<<< HEAD
  version = "23.09.11";
=======
  version = "23.04.28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-YipdEvmQnqiuxheYS+y5t37uonzr/nH54PVLm4xp31E=";
=======
    sha256 = "sha256-YiuXSYRiFyRh+dlZAvVViYGI2M57z1QPRb3JleL57Go=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Numix icon theme (square version)";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
