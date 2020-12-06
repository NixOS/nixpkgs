{ lib, buildDunePackage, cstruct, lwt }:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
	pname = "cstruct-lwt";
	inherit (cstruct) version src useDune2 meta;

  minimumOCamlVersion = "4.02";

	propagatedBuildInputs = [ cstruct lwt ];
}
