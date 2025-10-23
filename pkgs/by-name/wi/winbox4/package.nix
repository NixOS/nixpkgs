{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "winbox";
  version = "4.0beta33";

  metaCommon = {
    description = "Graphical configuration utility for RouterOS-based devices";
    homepage = "https://mikrotik.com";
    downloadPage = "https://mikrotik.com/download";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "WinBox";
    maintainers = with lib.maintainers; [
      Scrumplex
      yrd
      savalet
    ];
  };
  x86_64-zip = callPackage ./build-from-zip.nix {
    inherit pname version metaCommon;

    hash = "sha256-jGYqzmqH/0cbYoI5rGqSALzU8/dtDIKXCoFn9adDBZY=";
  };

  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;

    hash = "sha256-INMSKYGpXMBIF11Xaz+MLmCk78+rn7jf5BaFsErIG1E=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-zip).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    platforms = x86_64-zip.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "WinBox";
    changelog = "https://download.mikrotik.com/routeros/winbox/${oldAttrs.version}/CHANGELOG";
  };
})
