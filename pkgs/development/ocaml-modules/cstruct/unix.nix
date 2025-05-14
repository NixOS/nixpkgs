{
  lib,
  buildDunePackage,
  cstruct,
}:

if lib.versionOlder (cstruct.version or "1") "3" then
  cstruct
else

  buildDunePackage {
    pname = "cstruct-unix";
    inherit (cstruct) version src meta;

    minimalOCamlVersion = "4.08";
    duneVersion = "3";

    propagatedBuildInputs = [ cstruct ];
  }
