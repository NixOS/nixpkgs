{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "junicode";
  version = "1.003";

  src = fetchFromGitHub {
    owner = "psb1558";
    repo = "Junicode-font";
    rev = "55d816d91a5e19795d9b66edec478379ee2b9ddb";
    hash = "sha256-eTiMgI8prnpR4H6sqKRaB3Gcnt4C5QWZalRajWW49G4=";
  };

  installPhase = ''
    runHook preInstall

    local out_ttf=$out/share/fonts/junicode-ttf
    mkdir -p $out_ttf
    cp legacy/*.ttf $out_ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/psb1558/Junicode-font";
    description = "A Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
