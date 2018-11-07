{ buildDunePackage, cstruct }:

buildDunePackage {
	pname = "cstruct-unix";
	inherit (cstruct) version src unpackCmd meta;

  minimumOCamlVersion = "4.02";

	propagatedBuildInputs = [ cstruct ];
}
