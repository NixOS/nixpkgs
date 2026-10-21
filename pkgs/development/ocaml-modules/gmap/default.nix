{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  alcotest,
  fmt,
}:

buildDunePackage (finalAttrs: {
  pname = "gmap";
  version = "0.3.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/hannesm/gmap/releases/download/${finalAttrs.version}/gmap-${finalAttrs.version}.tbz";
    hash = "sha256-BN2eYiasj4+0zLYCEEhwLjSkgvucHSQNOFKClSlQfBw=";
  };

  minimalOCamlVersion = "4.03";

  checkInputs = [
    alcotest
    fmt
  ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    description = "Heterogenous maps over a GADT";
    homepage = "https://github.com/hannesm/gmap";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
