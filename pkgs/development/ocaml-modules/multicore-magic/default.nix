{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  domain_shims,
}:

buildDunePackage rec {
  pname = "multicore-magic";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/multicore-magic/releases/download/${version}/multicore-magic-${version}.tbz";
    hash = "sha256-r50UqLOd2DoTz0CEXHpJMHX0fty+mGiAKTdtykgnzu4=";
  };

  doCheck = true;

  checkInputs = [
    alcotest
    domain_shims
  ];

  meta = {
    description = "Low-level multicore utilities for OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/ocaml-multicore/multicore-magic";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
