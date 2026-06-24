{
  stdenv,
  lib,
  fetchFromGitHub,
  zilf,
}:
stdenv.mkDerivation {
  pname = "zork1-data";
  version = "0-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "historicalsource";
    repo = "zork1";
    rev = "97b7b3d68c075dd9af7da499c3e9690ada3471fd";
    hash = "sha256-zaSNTBTaRpnTzWOqwcqO8xxD4H2SbJTCwL//+xgP5kE=";
  };

  nativeBuildInputs = [ zilf ];

  buildPhase = ''
    runHook preBuild

    zilf build zork1.zil zork1.z3

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 zork1.z3 $out/share/games/zork1.z3

    runHook postInstall
  '';

  meta = {
    description = "1980 interactive fiction game written by Marc Blank, Dave Lebling, Bruce Daniels and Tim Anderson and published by Infocom";
    homepage = "https://github.com/historicalsource/zork1";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
}
