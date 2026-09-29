{
  lib,
  fetchurl,
  buildDunePackage,
  testo-util,
  cmdliner,
}:

buildDunePackage (finalAttrs: {
  pname = "testo";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/mjambon/testo/releases/download/${finalAttrs.version}/testo-${finalAttrs.version}.tbz";
    hash = "sha256-cPm+FSS1fCj3PCyEk37p93lHjpH6NZ3GNkKJjdExaXs=";
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
