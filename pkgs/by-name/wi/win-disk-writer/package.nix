{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "win-disk-writer";
  version = "1.3";

  src = fetchzip {
    url = "https://github.com/TechUnRestricted/WinDiskWriter/releases/download/v${finalAttrs.version}/WinDiskWriter.${finalAttrs.version}.zip";
    hash = "sha256-3+Pjp1T0u6G64W8dm4pWRiznDWNW4cMxTkoAIQgvtQY=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/WinDiskWriter.app"
    cp -R . "$out/Applications/WinDiskWriter.app/"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Windows Bootable USB creator for macOS";
    homepage = "https://github.com/TechUnRestricted/WinDiskWriter";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
