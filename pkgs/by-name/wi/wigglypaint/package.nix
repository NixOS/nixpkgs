{
  lib,
  stdenvNoCC,
  fetchurl,
  decker,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wigglypaint";
  version = "1.4";

  src = fetchurl {
    url = "https://web.archive.org/web/20260207010416if_/https://itchio-mirror.cb031a832f44726753d6267436f3b414.r2.cloudflarestorage.com/upload2/game/2398889/15143914?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=3edfcce40115d057d0b5606758e7e9ee%2F20260207%2Fauto%2Fs3%2Faws4_request&X-Amz-Date=20260207T010330Z&X-Amz-Expires=60&X-Amz-SignedHeaders=host&X-Amz-Signature=48f3a1889c8898ad615ea14c12ceb216ae61ae334a612b06da658b08c96b4d37";
    hash = "sha256-7Yoe0/QSDqOiOsuBmEeYpX2pV4NGCQDLZI5H0VQtPMY=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    install -Dm0644 "$src" "$out/share/wigglypaint/WigglyPaint.deck"
    makeWrapper ${decker}/bin/decker "$out/bin/wigglypaint" \
      --add-flags "$out/share/wigglypaint/WigglyPaint.deck"

    runHook postInstall
  '';

  meta = {
    description = "Juicy, jiggly drawing program built with Decker";
    homepage = "https://internet-janitor.itch.io/wigglypaint";
    downloadPage = "https://internet-janitor.itch.io/wigglypaint";
    license = lib.licenses.unfree;
    inherit (decker.meta) platforms;
    mainProgram = "wigglypaint";
    maintainers = with lib.maintainers; [ mio ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
