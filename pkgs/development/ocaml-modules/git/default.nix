{ lib, fetchurl, buildDunePackage
, alcotest, git, mtime, nocrypto
, angstrom, astring, cstruct, decompress, digestif, encore, duff, fmt
, fpath, hex, ke, logs, lru, ocaml_lwt, ocamlgraph, ocplib-endian, uri, rresult
}:

buildDunePackage rec {
  pname = "git";
	version = "2.1.2";

	src = fetchurl {
		url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
		sha256 = "0yyclsh255k7pvc2fcsdi8k2fcrr0by2nz6g3sqnwlimjyp7mz5j";
	};

	propagatedBuildInputs = [ angstrom astring cstruct decompress digestif encore duff fmt fpath hex ke logs lru ocaml_lwt ocamlgraph ocplib-endian uri rresult ];
	checkInputs = lib.optionals doCheck [ alcotest git mtime nocrypto ];
	doCheck = true;

	meta = {
		description = "Git format and protocol in pure OCaml";
		license = lib.licenses.isc;
		maintainers = [ lib.maintainers.vbgl ];
		homepage = "https://github.com/mirage/ocaml-git";
	};
}
