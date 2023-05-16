{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
, adwaita-icon-theme
, breeze-icons
, gnome-icon-theme
, hicolor-icon-theme
, gitUpdater
}:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme";
<<<<<<< HEAD
  version = "23.04.26";
=======
  version = "22.11.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-6tkE23G67nH/aZjDEtW64RcZsBrcd9iNj1r9lDlUFsk=";
=======
    sha256 = "sha256-B6Yg9NkPBpByMMV4GcEBmOlSKx1s0MClGWL2RWIJMwA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall

    substituteInPlace Numix/index.theme --replace Breeze breeze

    mkdir -p $out/share/icons
    cp -a Numix{,-Light} $out/share/icons/

    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Numix icon theme";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3Only;
    # darwin cannot deal with file names differing only in case
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
