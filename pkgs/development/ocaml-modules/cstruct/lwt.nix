{ lib, buildDunePackage, cstruct, lwt }:

if lib.versionOlder (cstruct.version or "1") "3"
then cstruct
else

  buildDunePackage {
    pname = "cstruct-lwt";
    inherit (cstruct) version src meta;

    minimalOCamlVersion = "4.08";
    duneVersion = "3";

    propagatedBuildInputs = [ cstruct lwt ];
  }
