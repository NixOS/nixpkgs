{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  adwaita-icon-theme,
  breeze-icons,
  gnome-icon-theme,
  hicolor-icon-theme,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "numix-icon-theme";
  version = "25.10.26";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-icon-theme";
    rev = version;
    sha256 = "sha256-YKR4dncq2uuX8CMJj/Zr/0pdl7gLC8VZGvb/HI1+Uwc=";
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
