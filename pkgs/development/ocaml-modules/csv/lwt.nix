{ lib, buildDunePackage, ocaml, csv, ocaml_lwt }:

if lib.versionOlder ocaml.version "4.02"
then throw "csv-lwt is not available for OCaml ${ocaml.version}"
else

buildDunePackage {
  pname = "csv-lwt";
  inherit (csv) src version useDune2 meta;

  propagatedBuildInputs = [ csv ocaml_lwt ];

  doCheck = lib.versionAtLeast ocaml.version "4.03";
}
