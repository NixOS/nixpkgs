{ lib, fetchurl, buildDunePackage, astring, result , version ? "1.0.0" }:

let param = {
  "1.0.0" = {
    sha256 = "sha256-tqoI6nGp662bK+vE2h7aDXE882dObVfRBFnZNChueqE=";
  };
  "0.9.0" = {
    sha256 = "sha256-3w2tG605v03mvmZsS2O5c71y66O3W+n3JjFxIbXwvXk=";
  };
}."${version}"; in

let v = version; in
buildDunePackage rec {
  pname = "odoc-parser";
  inherit version;

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml-doc/odoc-parser/releases/download/${version}/odoc-parser-${version}.tbz";
    inherit (param) sha256;
  };

  useDune2 = true;

  propagatedBuildInputs = [ astring result ];

  meta = {
    description = "Parser for Ocaml documentation comments";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.marsam ];
    homepage = "https://github.com/ocaml-doc/odoc-parser";
    changelog = "https://github.com/ocaml-doc/odoc-parser/raw/${version}/CHANGES.md";
  };
}
