{ lib, buildDunePackage, ocaml, csv, ocaml_lwt }:

buildDunePackage {
  pname = "csv-lwt";
  inherit (csv) src version useDune2 meta;
  minimumOCamlVersion = "4.02";

  propagatedBuildInputs = [ csv ocaml_lwt ];

  doCheck = lib.versionAtLeast ocaml.version "4.03";
}
