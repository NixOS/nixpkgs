{ lib, buildDunePackage, ocaml, csv, ocaml_lwt, uutf }:

buildDunePackage {
  pname = "csvtool";
  inherit (csv) src version meta;

  minimumOCamlVersion = "4.02";

  buildInputs = [ csv ocaml_lwt uutf ];

  useDune2 = true;

  doCheck = lib.versionAtLeast ocaml.version "4.03";
}
