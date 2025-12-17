{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "winbox";
  version = "4.0beta42";

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

    hash = "sha256-c+aewjTl+W/ahTdp9CIYT+MD4Nf+L58QONFCRifaOHI=";
  };

  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;

    hash = "sha256-3/sdKhMw2vx3IQE5IucllXzJyBs1snxXjAXNqumPQk0=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-zip).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    platforms = x86_64-zip.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "WinBox";
    changelog = "https://download.mikrotik.com/routeros/winbox/${oldAttrs.version}/CHANGELOG";
  };
})
