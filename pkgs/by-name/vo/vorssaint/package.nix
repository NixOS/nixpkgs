{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "vorssaint";
  version = "3.4.1";

  src = fetchurl {
    url = "https://github.com/vorssaint/vorssaint-utils/releases/download/v${finalAttrs.version}/Vorssaint-${finalAttrs.version}.dmg";
    hash = "sha256-08690HeVgmKU2CGUbLHUD16LhdKIOoEVPFUgRsyAqzo=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  # Preserve the signed upstream bundle without stripping or rewriting it.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R Vorssaint.app "$out/Applications/"
    runHook postInstall
  '';

  meta = {
    description = "Modular macOS menu bar toolkit";
    homepage = "https://github.com/vorssaint/vorssaint-utils";
    changelog = "https://github.com/vorssaint/vorssaint-utils/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.boborbt ];
  };
})
