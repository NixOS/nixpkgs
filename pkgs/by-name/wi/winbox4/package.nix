{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "winbox";
  version = "4.0beta16";
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
  x86_64-appimage = callPackage ./build-from-zip.nix {
    inherit pname version metaCommon;

    hash = "sha256-RZpsKew3BaId6+tcwUV6fniUpCH4wIP9ab6P5oE7OAk=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;

    hash = "sha256-ZxvuEVx9BmFukPMEPKeqXQNW38ExSpnRcSuHdw6j+CI=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-appimage).overrideAttrs
  (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // {
      inherit x86_64-appimage x86_64-dmg;
    };
    meta = oldAttrs.meta // {
      platforms = x86_64-appimage.meta.platforms ++ x86_64-dmg.meta.platforms;
      mainProgram = "caprine";
      changelog = "https://download.mikrotik.com/routeros/winbox/${oldAttrs.version}/CHANGELOG";
    };
  })
