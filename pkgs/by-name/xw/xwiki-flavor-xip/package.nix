{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xwiki-platform-distribution-flavor-xip";
  version = "18.0.1";

  src = fetchurl {
    url = "https://maven.xwiki.org/releases/org/xwiki/platform/xwiki-platform-distribution-flavor-xip/${finalAttrs.version}/xwiki-platform-distribution-flavor-xip-${finalAttrs.version}.xip";
    hash = "sha256-tF4TZIxrh5ywqSZ4T1+WfaqmbSFW47wzfnyDaz7Zp+U=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp ${finalAttrs.src} "$out"/xwiki-platform-distribution-flavor-xip-${finalAttrs.version}.xip
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.xwiki.org/";
    license = lib.licenses.lgpl21Plus;
    description = "XWiki flavor distribution package for offline installation";
    changelog = "https://www.xwiki.org/xwiki/bin/view/ReleaseNotes/Data/XWiki/${finalAttrs.version}/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [
      ThyMYthOS
    ];
    platforms = lib.platforms.unix;
  };
})
