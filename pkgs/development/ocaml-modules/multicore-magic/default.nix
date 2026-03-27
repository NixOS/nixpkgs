{
  lib,
  buildDunePackage,
  fetchurl,
  nodejs-slim,
  alcotest,
  domain_shims,
  js_of_ocaml,
}:

buildDunePackage rec {
  pname = "multicore-magic";
  version = "2.3.2";

  src = fetchurl {
    url = "https://github.com/ocaml-multicore/multicore-magic/releases/download/${version}/multicore-magic-${version}.tbz";
    hash = "sha256-jY1wqCOq4c4EMDgIQqqIHErIONJFyvJ+0P8ld1CHF18=";
  };

  doCheck = true;

  checkInputs = [
    alcotest
    domain_shims
  ];
  nativeCheckInputs = [
    nodejs-slim
    js_of_ocaml
  ];

  meta = {
    description = "Low-level multicore utilities for OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/ocaml-multicore/multicore-magic";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
