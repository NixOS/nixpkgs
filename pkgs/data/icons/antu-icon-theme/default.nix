{ lib, stdenvNoCC, fetchFromGitLab }:

stdenvNoCC.mkDerivation {
  pname = "antu-icon-theme";
  version = "0-unstable-2024-01-23";

  src = fetchFromGitLab {
    owner = "froodo_alexis";
    repo = "antu-icons";
    rev = "279be277";
    hash = "sha256-CLcr+X/b0moVEBV0O/dzCDq4w5G2+KRLUBdqKm0eAKA=";
  };

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/antu-icons
    cp -r * $out/share/icons/antu-icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "A smooth icon theme designed for Plasma Desktop";
    homepage = "https://gitlab.com/froodo_alexis/Antu-icons";
    changelog = "https://gitlab.com/froodo_alexis/Antu-icons/-/releases";
    license = licenses.cc-by-nc-sa-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ iamanaws ];
  };
}
