{ lib, fetchFromGitHub, buildDunePackage
, alcotest, git, mtime, nocrypto
, angstrom, astring, cstruct, decompress, digestif, encore, duff, fmt
, fpath, hex, ke, logs, lru, ocaml_lwt, ocamlgraph, ocplib-endian, uri, rresult
}:

buildDunePackage rec {
  pname = "git";
	version = "2.1.0";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-git";
		rev = version;
		sha256 = "0v55zkwgml6i5hp0kzynbi58z6j15k3qgzg06b3h8pdbv5fwd1jp";
	};

	propagatedBuildInputs = [ angstrom astring cstruct decompress digestif encore duff fmt fpath hex ke logs lru ocaml_lwt ocamlgraph ocplib-endian uri rresult ];
	checkInputs = lib.optionals doCheck [ alcotest git mtime nocrypto ];
	doCheck = true;

	meta = {
		description = "Git format and protocol in pure OCaml";
		license = lib.licenses.isc;
		maintainers = [ lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
