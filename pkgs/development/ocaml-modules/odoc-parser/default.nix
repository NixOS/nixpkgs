{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  astring,
  result,
  camlp-streams,
  version ? if lib.versionAtLeast ocaml.version "4.08" then "3.1.0" else "2.4.4",
}:

let
  param =
    {
      "3.1.0" = {
        sha256 = "sha256-NVs8//STSQPLrti1HONeMz6GCZMtIwKUIAqfLUL/qRQ=";
      };
      "2.4.4" = {
        sha256 = "sha256-fiU6VbXI9hD54LSJQOza8hwBVTFDr5O0DJmMMEmeUfM=";
      };
      "2.0.0" = {
        sha256 = "sha256-QHkZ+7DrlXYdb8bsZ3dijZSqGQc0O9ymeLGIC6+zOSI=";
      };
      "1.0.1" = {
        sha256 = "sha256-orvo5CAbYOmAurAeluQfK6CwW6P1C0T3WDfoovuQfSw=";
      };
      "1.0.0" = {
        sha256 = "sha256-tqoI6nGp662bK+vE2h7aDXE882dObVfRBFnZNChueqE=";
        max_version = "5.0";
      };
      "0.9.0" = {
        sha256 = "sha256-3w2tG605v03mvmZsS2O5c71y66O3W+n3JjFxIbXwvXk=";
        max_version = "5.0";
      };
    }
    ."${version}";
in

lib.throwIf (param ? max_version && lib.versionAtLeast ocaml.version param.max_version)
  "odoc-parser ${version} is not available for OCaml ${ocaml.version}"

  buildDunePackage
  rec {
    pname = "odoc-parser";
    inherit version;

    src = fetchurl {
      url =
        if lib.versionAtLeast version "2.4" then
          "https://github.com/ocaml/odoc/releases/download/${version}/odoc-${version}.tbz"
        else
          "https://github.com/ocaml-doc/odoc-parser/releases/download/${version}/odoc-parser-${version}.tbz";
      inherit (param) sha256;
    };

    propagatedBuildInputs = [
      astring
    ]
    ++ lib.optional (!lib.versionAtLeast version "3.1.0") result
    ++ lib.optional (lib.versionAtLeast version "1.0.1") camlp-streams;

    meta = {
      description = "Parser for Ocaml documentation comments";
      license = lib.licenses.isc;
      maintainers = with lib.maintainers; [ momeemt ];
      homepage = "https://github.com/ocaml-doc/odoc-parser";
      changelog = "https://github.com/ocaml-doc/odoc-parser/raw/${version}/CHANGES.md";
    };
  }
