{ lib, stdenvNoCC, fetchFromGitHub, gtk3, plasma5Packages, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "oranchelo-icon-theme";
  version = "0.8.0.1";

  src = fetchFromGitHub {
    owner = "OrancheloTeam";
    repo = pname;
    rev = "096c8c8d550ac9a85f5f34f3f30243e6f198df2d";
    sha256 = "sha256-TKi42SA33pGKdrPtGTpvxFbOP+5N93Y4BvO4CRTveLM=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    plasma5Packages.breeze-icons
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r $Oranchelo* $out/share/icons/
  '';

  meta = with lib; {
    description = "Oranchelo icon theme";
    homepage = "https://github.com/OrancheloTeam/oranchelo-icon-theme";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ _414owen ];
  };
}
