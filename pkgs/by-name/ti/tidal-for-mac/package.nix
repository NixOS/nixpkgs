{
  lib,
  fetchzip,
  stdenvNoCC,
  writeShellApplication,
  curl,
  jq,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tidal-for-mac";
  version = "2.41.3";

  src = fetchzip {
    url = "https://download.tidal.com/desktop/mac/TIDAL.arm64.${finalAttrs.version}.zip";
    hash = "sha256-hkaxCWIIyEOl9dg9SkkRQUL3UA8+OcBPV9ICQOWTi+w=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/Tidal.app"
    cp -R Contents "$out/Applications/Tidal.app/"

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "tidal-update-script";
    runtimeInputs = [
      curl
      jq
      common-updater-scripts
    ];
    text = ''
      version=$(curl -s "https://formulae.brew.sh/api/cask/tidal.json" | jq -r '.version')
      update-source-version tidal-for-mac "$version" --file=./pkgs/by-name/ti/tidal-for-mac/package.nix
    '';
  });

  meta = {
    description = "Native desktop client for Tidal";
    homepage = "https://tidal.com/";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [ lykaz ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
