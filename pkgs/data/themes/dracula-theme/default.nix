{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

let
  themeName = "Dracula";
  version = "2.0";
in
stdenv.mkDerivation {
  pname = "dracula-theme";
  inherit version;

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "v${version}";
    sha256 = "10j706gnhdplhykdisp64vzzxpzgn48b5f1fkndcp340x7hf2mf3";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a {assets,cinnamon,gnome-shell,gtk-2.0,gtk-3.0,gtk-3.20,index.theme,kde,metacity-1,unity,xfwm4} $out/share/themes/${themeName}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dracula variant of the Ant theme";
    homepage = "https://github.com/dracula/gtk";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice vonfry ];
  };
}
