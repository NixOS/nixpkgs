{
  lib,
  callPackage,
  stdenvNoCC,
}:
let
  pname = "winbox";
<<<<<<< HEAD
  version = "4.0beta44";
=======
  version = "4.0beta41";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
    hash = "sha256-LPq7KPOj59NUhoQCxpAVW8qbjXJGxRw8fRJT7/qDtZM=";
=======
    hash = "sha256-oKDLNHQLMdZb18pPTpoSc5gwljHkSMmyITZ0ATBdR08=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;

<<<<<<< HEAD
    hash = "sha256-96lb8a70dmqieKn5Nr61sZg/aVDLz0sY64sfN83rU+0=";
=======
    hash = "sha256-9jG+xlmRy011DA4BwOGRMpzU0qy0qbjiN3nR3xMJpbo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-zip).overrideAttrs (oldAttrs: {
  meta = oldAttrs.meta // {
    platforms = x86_64-zip.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "WinBox";
    changelog = "https://download.mikrotik.com/routeros/winbox/${oldAttrs.version}/CHANGELOG";
  };
})
