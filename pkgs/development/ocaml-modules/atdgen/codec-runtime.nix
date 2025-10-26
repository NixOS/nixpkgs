{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "atdgen-codec-runtime";
  version = "3.0.1";

  src = fetchurl {
    url = "https://github.com/ahrefs/atd/releases/download/${finalAttrs.version}/atd-${finalAttrs.version}.tbz";
    hash = "sha256-A66uRWWjLYu2ishRSvXvx4ALFhnClzlBynE4sSs0SIQ=";
  };

  meta = {
    description = "Runtime for atdgen generated bucklescript converters";
    homepage = "https://github.com/ahrefs/atd";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
})
