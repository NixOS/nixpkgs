{ lib, buildDunePackage, cstruct }:

buildDunePackage {
  pname = "cstruct-unix";
  inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.06";

  propagatedBuildInputs = [ cstruct ];
}
