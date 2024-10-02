{ lib, fetchurl, buildDunePackage, fmt, alcotest, crowbar }:

buildDunePackage rec {
  pname = "cstruct";
  version = "6.2.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    hash = "sha256-mngHM5JYDoNJFI+jq0sbLpidydMNB0AbBMlrfGDwPmI=";
  };

  buildInputs = [ fmt ];

  doCheck = true;
  checkInputs = [ alcotest crowbar ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
