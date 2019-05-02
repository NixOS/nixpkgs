{ lib, buildDunePackage, ocaml, csv, ocaml_lwt }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "csv-lwt is not available for OCaml ${ocaml.version}"
else

buildDunePackage {
  pname = "csv-lwt";
  inherit (csv) src version meta;

  propagatedBuildInputs = [ csv ocaml_lwt ];

  doCheck = lib.versionAtLeast ocaml.version "4.03";
}
