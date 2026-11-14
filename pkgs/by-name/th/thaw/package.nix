{
  lib,
  stdenvNoCC,
  unzip,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "thaw";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/thaw-app/Thaw/releases/download/${finalAttrs.version}/Thaw_${finalAttrs.version}.zip";
    hash = "sha256-I/6FDda24/girwCi2nbG1GE1wvqKDe746PoJ0e/T7sE=";
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
    description = "Open source menu bar manager for macOS";
    homepage = "https://github.com/thaw-app/Thaw";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
