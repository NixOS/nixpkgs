{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  stdlib-shims,
  ounit,
}:

buildDunePackage (finalAttrs: {
  pname = "diet";
  version = "0.4";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-diet/releases/download/v${finalAttrs.version}/diet-v${finalAttrs.version}.tbz";
    hash = "sha256-lqysLk/e219H3YrSVi5yPYWrWc0b2FVU3yHskHsHF0E=";
  };

  minimalOCamlVersion = "4.03";

  propagatedBuildInputs = [ stdlib-shims ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ ounit ];

  meta = {
    homepage = "https://github.com/mirage/ocaml-diet";
    description = "Simple implementation of Discrete Interval Encoding Trees";
    license = lib.licenses.isc;
  };
})
