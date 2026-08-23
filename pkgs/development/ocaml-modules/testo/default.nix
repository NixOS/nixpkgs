{
  lib,
  fetchurl,
  buildDunePackage,
  testo-util,
  cmdliner,
}:

buildDunePackage (finalAttrs: {
  pname = "testo";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/mjambon/testo/releases/download/${finalAttrs.version}/testo-${finalAttrs.version}.tbz";
    hash = "sha256-95Gdn5+kVxxbGtYn36jAXk15+GVHRaa+szO5W0WWEbE=";
  };

  propagatedBuildInputs = [
    cmdliner
    testo-util
  ];

  meta = {
    homepage = "https://github.com/mjambon/testo";
    license = lib.licenses.isc;
    description = "Test framework for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
