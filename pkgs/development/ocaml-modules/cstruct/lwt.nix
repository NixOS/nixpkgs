{ lib, buildDunePackage, cstruct, lwt }:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
  pname = "cstruct-lwt";
  inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.03";

  propagatedBuildInputs = [ cstruct lwt ];
}
