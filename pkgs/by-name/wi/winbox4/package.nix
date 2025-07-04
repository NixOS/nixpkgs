{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "winbox";
  version = "4.0beta21";

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

    hash = "sha256-Uoawz+CW1JLVOEoxSF49WpF31VuUDWK4q9tl1qAwS/c=";
  };

  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;

    hash = "sha256-PCdN5z77RU5WgYzk2h/ou2OeswZQl32FfxozEZ8ZlTo=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-zip).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    platforms = x86_64-zip.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "WinBox";
    changelog = "https://download.mikrotik.com/routeros/winbox/${oldAttrs.version}/CHANGELOG";
  };
})
