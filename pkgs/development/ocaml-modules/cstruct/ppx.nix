{ buildDunePackage, cstruct, ppx_tools_versioned }:

buildDunePackage {
	pname = "ppx_cstruct";
	inherit (cstruct) version src unpackCmd meta;

  minimumOCamlVersion = "4.02";

	buildInputs = [ ppx_tools_versioned ];
	propagatedBuildInputs = [ cstruct ];
}
