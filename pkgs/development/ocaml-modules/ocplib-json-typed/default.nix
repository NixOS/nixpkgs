{ lib, buildDunePackage, fetchFromGitHub, uri }:

buildDunePackage rec {
	pname = "ocplib-json-typed";
	version = "0.7.1";
	src = fetchFromGitHub {
		owner = "OCamlPro";
		repo = "ocplib-json-typed";
		rev = "v${version}";
		sha256 = "1gv0vqqy9lh7isaqg54b3lam2sh7nfjjazi6x7zn6bh5f77g1p5q";
	};

	propagatedBuildInputs = [ uri ];

	meta = {
		description = "A collection of type-aware JSON utilities for OCaml";
		license = lib.licenses.lgpl21;
		maintainers = [ lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
