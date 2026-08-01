{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "grenier";
  version = "0.16";
  src = fetchurl {
    url = "https://github.com/let-def/grenier/releases/download/v${finalAttrs.version}/grenier-${finalAttrs.version}.tbz";
    hash = "sha256-j9Iqv59FicIGAIZU+p7rsc9KWHN+uzQTjGcJUg82t18=";
  };

  doCheck = true;

  meta = {
    description = "A collection of various algorithms in OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/let-def/grenier";
  };
})
