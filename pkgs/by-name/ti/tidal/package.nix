{
  lib,
  stdenv,
  fetchurl,
  undmg,
}:
let
  updateScript = ./update.sh;
in
stdenv.mkDerivation {
  pname = "tidal";
  version = "2.41.3";

  src =
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://web.archive.org/web/20260314112555/https://download.tidal.com/desktop/TIDAL.arm64.dmg";
        hash = "sha256-18RjsLHhpUSAyITfwu3efokUbezE1b3GpFiafWHW/qo=";
      })
    else
      (fetchurl {
        url = "https://web.archive.org/web/20260314112436/https://download.tidal.com/desktop/TIDAL.x64.dmg";
        hash = "sha256-5nUU8TOSph1v1C0+/KR/F5Y7m5TitbYH/ujsiZ/n6LU=";
      });

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  strictDeps = true;
  __structuredAttrs = true;

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru = { inherit updateScript; };

  meta = {
    description = "Play music from the Tidal streaming service";
    homepage = "https://tidal.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "tidal";
    maintainers = with lib.maintainers; [
      frostplexx
    ];
  };
}
