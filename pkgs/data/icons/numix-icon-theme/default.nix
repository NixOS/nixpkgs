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
  version = "23.12.02";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = pname;
    rev = version;
    sha256 = "sha256-ks2JJROSYzeDqq7i6Y4iJAB994ZRcDOGGRcCL3Dt1zI=";
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
