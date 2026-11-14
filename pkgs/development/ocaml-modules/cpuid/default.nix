{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage (finalAttrs: {
  pname = "cpuid";
  version = "0.1.2";

  src = fetchurl {
    url = "https://github.com/pqwy/cpuid/releases/download/v${finalAttrs.version}/cpuid-v${finalAttrs.version}.tbz";
    hash = "sha256-I1VyNDEox7cenlwvxjFhs9njK8ir53ljWXRho3YlzyI=";
  };

  meta = {
    homepage = "https://github.com/pqwy/cpuid";
    description = "Detect CPU features from OCaml";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
