{
  fetchurl,
  buildDunePackage,
  lib,
}:

buildDunePackage (finalAttrs: {
  pname = "bstr";
  version = "0.1.1";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/robur-coop/bstr/releases/download/v${finalAttrs.version}/bstr-${finalAttrs.version}.tbz";
    hash = "sha256-5lfP/aVpELFLmMdt1uA4LqS8XQFn6IORq6kxlrAW7uA=";
  };

  meta = {
    description = "A simple library for bigstrings";
    homepage = "https://git.robur.coop/robur/bstr";
    license = [
      lib.licenses.mit
      lib.licenses.isc
    ];
    maintainers = [ lib.maintainers.vbgl ];
  };
})
