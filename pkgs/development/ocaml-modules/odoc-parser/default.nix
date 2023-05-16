<<<<<<< HEAD
{ lib, fetchurl, buildDunePackage, ocaml, astring, result, camlp-streams, version ? "2.0.0" }:
=======
{ lib, fetchurl, buildDunePackage, astring, result, camlp-streams, version ? "2.0.0" }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    max_version = "5.0";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extraBuildInputs = [];
  };
  "0.9.0" = {
    sha256 = "sha256-3w2tG605v03mvmZsS2O5c71y66O3W+n3JjFxIbXwvXk=";
<<<<<<< HEAD
    max_version = "5.0";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    extraBuildInputs = [];
  };
}."${version}"; in

<<<<<<< HEAD
lib.throwIf (param ? max_version && lib.versionAtLeast ocaml.version param.max_version)
  "odoc-parser ${version} is not available for OCaml ${ocaml.version}"

=======
let v = version; in
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
buildDunePackage rec {
  pname = "odoc-parser";
  inherit version;

<<<<<<< HEAD
  minimalOCamlVersion = "4.02";
=======
  minimumOCamlVersion = "4.02";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://github.com/ocaml-doc/odoc-parser/releases/download/${version}/odoc-parser-${version}.tbz";
    inherit (param) sha256;
  };

<<<<<<< HEAD
=======
  useDune2 = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [ astring result ] ++ param.extraBuildInputs;

  meta = {
    description = "Parser for Ocaml documentation comments";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.marsam ];
    homepage = "https://github.com/ocaml-doc/odoc-parser";
    changelog = "https://github.com/ocaml-doc/odoc-parser/raw/${version}/CHANGES.md";
  };
}
