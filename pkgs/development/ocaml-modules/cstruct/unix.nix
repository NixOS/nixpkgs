{ lib, buildDunePackage, cstruct }:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
	pname = "cstruct-unix";
	inherit (cstruct) version src meta;

  minimumOCamlVersion = "4.02";

	propagatedBuildInputs = [ cstruct ];
}
