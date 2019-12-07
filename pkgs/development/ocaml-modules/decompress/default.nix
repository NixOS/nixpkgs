{ lib, fetchurl, buildDunePackage
, checkseum, cmdliner
, alcotest, bos, camlzip, mmap, re
}:

buildDunePackage rec {
	version = "0.9.0";
	pname = "decompress";

	src = fetchurl {
		url = "https://github.com/mirage/decompress/releases/download/v${version}/decompress-v${version}.tbz";
		sha256 = "0fryhcvv96vfca51c7kqdn3n3canqsbbvfbi75ya6lca4lmpipbh";
	};

	buildInputs = [ cmdliner ];
	propagatedBuildInputs = [ checkseum ];
	checkInputs = lib.optionals doCheck [ alcotest bos camlzip mmap re ];
	doCheck = true;

	meta = {
		description = "Pure OCaml implementation of Zlib";
		license = lib.licenses.mit;
		maintainers = [ lib.maintainers.vbgl ];
		homepage = "https://github.com/mirage/decompress";
	};
}
