{ lib, fetchurl, buildDunePackage, bigarray-compat, alcotest, ocaml }:

buildDunePackage rec {
  pname = "cstruct";
  version = "6.0.1";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-v${version}.tbz";
    sha256 = "4a67bb8f042753453c59eabf0e47865631253ba694091ce6062aac05d47a9bed";
  };

  propagatedBuildInputs = [ bigarray-compat ];

  # alcotest isn't available for OCaml < 4.08 due to fmt
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
