{ lib, stdenvNoCC, fetchFromGitHub, gtk-engine-murrine }:

let
  themeName = "Dracula";
  version = "4.0.0";
in
stdenvNoCC.mkDerivation {
  pname = "dracula-theme";
  inherit version;

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "v${version}";
    hash = "sha256-q3/uBd+jPFhiVAllyhqf486Jxa0mnCDSIqcm/jwGtJA=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a {assets,cinnamon,gnome-shell,gtk-2.0,gtk-3.0,gtk-3.20,gtk-4.0,index.theme,metacity-1,unity,xfwm4} $out/share/themes/${themeName}

    cp -a kde/{color-schemes,plasma} $out/share/
    cp -a kde/kvantum $out/share/Kvantum
    mkdir -p $out/share/aurorae/themes
    cp -a kde/aurorae/* $out/share/aurorae/themes/
    mkdir -p $out/share/sddm/themes
    cp -a kde/sddm/* $out/share/sddm/themes/

    mkdir -p $out/share/icons/Dracula-cursors
    mv kde/cursors/Dracula-cursors/index.theme $out/share/icons/Dracula-cursors/cursor.theme
    mv kde/cursors/Dracula-cursors/cursors $out/share/icons/Dracula-cursors/cursors

    runHook postInstall
  '';

  meta = with lib; {
    description = "Dracula variant of the Ant theme";
    homepage = "https://github.com/dracula/gtk";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
  };
}
