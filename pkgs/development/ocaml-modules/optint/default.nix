{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  minimalOCamlVersion = "4.07";
  version = "0.3.1";
  pname = "optint";
  src = fetchurl {
    url = "https://github.com/mirage/optint/releases/download/v${finalAttrs.version}/optint-${finalAttrs.version}.tbz";
    hash = "sha256-4M2YHcSzUYEpvuRgy13FLGFCzwS5w3MD0pJWCBrprVo=";
  };

  meta = {
    homepage = "https://github.com/mirage/optint";
    description = "Abstract type of integer between x64 and x86 architecture";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
