{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "winbox";
  version = "4.0beta35";

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

    hash = "sha256-gmFAxa9ogFwbSZ9yOCkDzHDoRwc3FRx/HS9/yqdUpZc=";
  };

  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;

    hash = "sha256-FeUEr9Kpu92NDOyp8inpSvx42xRboHb/Ey3Bo4S91S0=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-zip).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    platforms = x86_64-zip.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "WinBox";
    changelog = "https://download.mikrotik.com/routeros/winbox/${oldAttrs.version}/CHANGELOG";
  };
})
