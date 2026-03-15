{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xwiki";
  version = "18.0.1";

  src = fetchurl {
    url = "https://maven.xwiki.org/releases/org/xwiki/platform/xwiki-platform-distribution-war/${finalAttrs.version}/xwiki-platform-distribution-war-${finalAttrs.version}.war";
    hash = "sha256-HDfuurGGuy6EQdjvLceyDi2lP5dnYnIFqI/SzbUDYeE=";
  };

  buildCommand = ''
    mkdir -p "$out"/webapps/
    ln -s ${finalAttrs.src} "$out"/webapps/xwiki-${finalAttrs.version}.war
  '';

  meta = {
    homepage = "https://www.xwiki.org/";
    license = lib.licenses.lgpl21Plus;
    description = "Enterprise wiki package as a WAR archive";
    changelog = "https://www.xwiki.org/xwiki/bin/view/ReleaseNotes/Data/XWiki/${finalAttrs.version}/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [
      ThyMYthOS
    ];
    platforms = lib.platforms.unix;
  };
})
