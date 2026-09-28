{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "thaw";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/stonerl/Thaw/releases/download/${finalAttrs.version}/Thaw_${finalAttrs.version}.zip";
    hash = "sha256-1n9NMe+foFeEmphUC4EM+kLgvGYBnTYFq9CORcaaoG8=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -r Thaw.app "$out/Applications"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Menu bar manager for macOS 26";
    homepage = "https://github.com/stonerl/Thaw";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
