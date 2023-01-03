{ lib, fetchurl, buildDunePackage, fmt, alcotest, crowbar }:

buildDunePackage rec {
  pname = "cstruct";
  version = "6.1.1";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${version}/cstruct-${version}.tbz";
    sha256 = "sha256-G3T5hw9qfuYAiSRZBxbdUzpyijyhC7GNqf6ovkZ/UY0=";
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
