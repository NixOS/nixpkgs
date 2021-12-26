{ lib, fetchurl, buildDunePackage, astring, result }:

buildDunePackage rec {
  pname = "odoc-parser";
  version = "1.0.0";

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml-doc/odoc-parser/releases/download/${version}/odoc-parser-${version}.tbz";
    sha256 = "sha256-tqoI6nGp662bK+vE2h7aDXE882dObVfRBFnZNChueqE=";
  };

  useDune2 = true;

  buildInputs = [ astring result ];

  meta = {
    description = "Parser for Ocaml documentation comments";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.marsam ];
    homepage = "https://github.com/ocaml-doc/odoc-parser";
    changelog = "https://github.com/ocaml-doc/odoc-parser/raw/${version}/CHANGES.md";
  };
}
