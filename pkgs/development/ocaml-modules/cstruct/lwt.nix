{ lib, buildDunePackage, cstruct, lwt }:

buildDunePackage {
  pname = "cstruct-lwt";
  inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ cstruct lwt ];
}
