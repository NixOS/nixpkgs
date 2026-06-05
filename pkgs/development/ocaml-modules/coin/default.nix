{
  buildDunePackage,
  fetchurl,
  lib,
}:

buildDunePackage (finalAttrs: {
  pname = "coin";
  version = "0.1.5";
  minimalOCamlVersion = "4.06";

  src = fetchurl {
    url = "https://github.com/mirage/coin/releases/download/v${finalAttrs.version}/coin-${finalAttrs.version}.tbz";
    hash = "sha256-z2WzQ7zUFmZJTUqygTHguud6+NAcp36WubHbILXGR9g=";
  };

  doCheck = true;

  meta = {
    description = "Library to normalize an KOI8-{U,R} input to Unicode";
    homepage = "https://github.com/mirage/coin";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "coin.generate";
  };
})
