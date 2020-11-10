{ lib, buildDunePackage, cstruct, sexplib, ppx_tools_versioned }:

if !lib.versionAtLeast (cstruct.version or "1") "3"
then cstruct
else

buildDunePackage {
	pname = "ppx_cstruct";
	inherit (cstruct) version src meta;

	minimumOCamlVersion = "4.03";

	propagatedBuildInputs = [ cstruct ppx_tools_versioned sexplib ];
}
