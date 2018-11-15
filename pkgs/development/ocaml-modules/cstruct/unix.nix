{ buildDunePackage, cstruct }:

buildDunePackage {
	pname = "cstruct-unix";
	inherit (cstruct) version src meta;

  minimumOCamlVersion = "4.02";

	propagatedBuildInputs = [ cstruct ];
}
