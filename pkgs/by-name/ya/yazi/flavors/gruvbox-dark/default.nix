{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "gruvbox-dark";
  version = "0-unstable-2026-05-13";
  src = fetchFromGitHub {
    owner = "bennyyip";
    repo = "gruvbox-dark.yazi";
    rev = "619fdc5844db0c04f6115a62cf218e707de2821e";
    hash = "sha256-Y/i+eS04T2+Sg/Z7/CGbuQHo5jxewXIgORTQm25uQb4=";
  };
  installPhase = ''
    runHook preInstall

    install -D $src/* -t $out

    runHook postInstall
  '';
  meta = {
    description = "Gruvbox Dark Flavor for Yazi";
    homepage = "https://github.com/bennyyip/gruvbox-dark.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [valyntyler];
  };
}
