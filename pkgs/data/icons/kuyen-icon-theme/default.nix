{ lib, stdenvNoCC, fetchFromGitLab }:

stdenvNoCC.mkDerivation rec {
  pname = "kuyen-icon-theme";
  version = "0-unstable-2024-01-27";

  src = fetchFromGitLab {
    owner = "froodo_alexis";
    repo = "kuyen-icons";
    rev = "9fc6c0e4";
    hash = "sha256-6BK6+6CZhcPgDNuBIF9cYXGwS414NlL+KvRdsDzziaQ=";
  };

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
  
    mkdir -p $out/share/icons/kuyen-icons
    cp -r * $out/share/icons/kuyen-icons
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "A colourful flat theme designed for Plasma Desktop";
    homepage = "https://gitlab.com/froodo_alexis/kuyen-icons";
    changelog = "https://gitlab.com/froodo_alexis/kuyen-icons/-/releases";
    license = licenses.cc-by-nc-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ iamanaws ];
  };
}
