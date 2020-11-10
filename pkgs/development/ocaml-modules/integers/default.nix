{ lib, fetchzip, buildDunePackage }:

buildDunePackage rec {
	pname = "integers";
	version = "0.3.0";

	src = fetchzip {
		url = "https://github.com/ocamllabs/ocaml-integers/archive/${version}.tar.gz";
		sha256 = "1yhif5zh4srh63mhimfx3p5ljpb3lixjdd3i9pjnbj2qgpzlqj8p";
	};

	meta = {
		description = "Various signed and unsigned integer types for OCaml";
		license = lib.licenses.mit;
		homepage = "https://github.com/ocamllabs/ocaml-integers";
		maintainers = [ lib.maintainers.vbgl ];
	};
}
