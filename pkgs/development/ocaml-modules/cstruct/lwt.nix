{ buildDunePackage, cstruct, lwt }:

buildDunePackage {
	pname = "cstruct-lwt";
	inherit (cstruct) version src meta;

  minimumOCamlVersion = "4.02";

	propagatedBuildInputs = [ cstruct lwt ];
}
