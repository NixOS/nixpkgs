{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage (finalAttrs: {
  pname = "binning";
  version = "0.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/pveber/binning/releases/download/v${finalAttrs.version}/binning-v${finalAttrs.version}.tbz";
    hash = "sha256-eG+xctsbc7lQ5pFOUtJ8rjNW/06gygwLADq7yc8Yf/c=";
  };

  meta = {
    description = "Datastructure to accumulate values in bins";
    license = lib.licenses.cecill-b;
    homepage = "https://github.com/pveber/binning/";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
