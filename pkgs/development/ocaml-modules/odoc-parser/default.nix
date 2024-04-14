{ lib, fetchurl, buildDunePackage, ocaml, astring, result, camlp-streams, version ? "2.0.0" }:

let param = {
  "2.0.0" = {
    sha256 = "sha256-QHkZ+7DrlXYdb8bsZ3dijZSqGQc0O9ymeLGIC6+zOSI=";
    extraBuildInputs = [ camlp-streams ];
  };
  "1.0.1" = {
    sha256 = "sha256-orvo5CAbYOmAurAeluQfK6CwW6P1C0T3WDfoovuQfSw=";
    extraBuildInputs = [ camlp-streams ];
  };
  "1.0.0" = {
    sha256 = "sha256-tqoI6nGp662bK+vE2h7aDXE882dObVfRBFnZNChueqE=";
    max_version = "5.0";
    extraBuildInputs = [];
  };
  "0.9.0" = {
    sha256 = "sha256-3w2tG605v03mvmZsS2O5c71y66O3W+n3JjFxIbXwvXk=";
    max_version = "5.0";
    extraBuildInputs = [];
  };
}."${version}"; in

lib.throwIf (param ? max_version && lib.versionAtLeast ocaml.version param.max_version)
  "odoc-parser ${version} is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "odoc-parser";
  inherit version;

  minimalOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/ocaml-doc/odoc-parser/releases/download/${version}/odoc-parser-${version}.tbz";
    inherit (param) sha256;
  };

  propagatedBuildInputs = [ astring result ] ++ param.extraBuildInputs;

  meta = {
    description = "Parser for Ocaml documentation comments";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.marsam ];
    homepage = "https://github.com/ocaml-doc/odoc-parser";
    changelog = "https://github.com/ocaml-doc/odoc-parser/raw/${version}/CHANGES.md";
  };
}
