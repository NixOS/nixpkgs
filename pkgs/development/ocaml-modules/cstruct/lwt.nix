{ buildDunePackage, cstruct, lwt }:

buildDunePackage {
	pname = "cstruct-lwt";
	inherit (cstruct) version src unpackCmd meta;

  minimumOCamlVersion = "4.02";

	propagatedBuildInputs = [ cstruct lwt ];
}
