{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zip2hashcat";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "hashstation";
    repo = "zip2hashcat";
    # Upstream 1.0 tag has no content
    rev = "462bd94ea30d69a0810ca9bb3d056aa0f5393d57";
    hash = "sha256-+hbDTGSDUxA7M8gBI/TViJ2ZvheNxlonYC/aFLvgPW8=";
  };

  buildPhase = ''
    runHook preBuild

    $CC zip2hashcat.c -o zip2hashcat

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv zip2hashcat $out/bin/zip2hashcat

    runHook postInstall
  '';

  meta = {
    description = "Processes input ZIP files into a format suitable for use with hashcat";
    homepage = "https://github.com/hashstation/zip2hashcat";
    license = lib.licenses.mit;
    changelog = "https://github.com/hashstation/zip2hashcat/releases/tag/${version}";
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "zip2hashcat";
    platforms = lib.platforms.all;
  };
}
