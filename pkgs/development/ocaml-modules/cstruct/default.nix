{ lib, fetchurl, buildDunePackage, bigarray-compat, alcotest, ocaml }:

buildDunePackage rec {
  pname = "cstruct";
  version = "6.0.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-v${version}.tbz";
    sha256 = "0xi6cj85z033fqrqdkwac6gg07629vzdhx03c3lhiwwc4lpnv8bq";
  };

  propagatedBuildInputs = [ bigarray-compat ];

  # alcotest isn't available for OCaml < 4.05 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ alcotest ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
