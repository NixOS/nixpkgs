{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "opti";
  version = "1.0.3";

  src = fetchurl {
    url = "https://github.com/magnusjonsson/opti/releases/download/${finalAttrs.version}/opti-${finalAttrs.version}.tbz";
    hash = "sha256-7ZulbcBunSsb8JeWTMZeo323h9TyOcE9DddGk/W1Ch4=";
  };

  meta = {
    description = "DSL to generate fast incremental C code from declarative specifications";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jmagnusj ];
    homepage = "https://github.com/magnusjonsson/opti";
  };
})
