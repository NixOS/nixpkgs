{ lib, fetchFromGitHub, stdenvNoCC }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "league-script-number-one";
  version = "2011-05-25";

  src = fetchFromGitHub {
    owner = "theleagueof";
    repo = finalAttrs.pname;
    rev = "225add0b37cf8268759ba4572e02630d9fb54ecf";
    hash = "sha256-Z3Zrp0Os3On0tESVical1Qh6wY1H2Hc0OPTlkbtsrCI=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Modern, coquettish script font";
    longDescription = ''
      This ain’t no Lucinda. League Script #1 is a modern, coquettish script
      font that sits somewhere between your high school girlfriend’s love notes
      and handwritten letters from the ’20s. Designed exclusively for the
      League of Moveable Type, it includes ligatures and will act as the
      framework for future script designs.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/league-script";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson ];
  };
})
