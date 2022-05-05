{ lib, buildDunePackage, cstruct }:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
  pname = "cstruct-unix";
  inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.06";

  propagatedBuildInputs = [ cstruct ];
}
