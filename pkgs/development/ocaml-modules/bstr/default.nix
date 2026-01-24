{
  fetchurl,
  buildDunePackage,
  lib,
}:

buildDunePackage (finalAttrs: {
  pname = "bstr";
  version = "0.0.4";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/robur-coop/bstr/releases/download/v${finalAttrs.version}/bstr-${finalAttrs.version}.tbz";
    hash = "sha256-ZAg28VstVVvfI2b213g5JuEVmK1+lFV7Fnx4WyVfSFY=";
  };

  meta = {
    description = "A simple library for bigstrings";
    homepage = "https://git.robur.coop/robur/bstr";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
