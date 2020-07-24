{ stdenv, fetchurl, buildDunePackage
, alcotest, mtime, mirage-crypto-rng, tls, git-binary
, angstrom, astring, cstruct, decompress, digestif, encore, duff, fmt, checkseum
, fpath, hex, ke, logs, lru, ocaml_lwt, ocamlgraph, ocplib-endian, uri, rresult
, stdlib-shims
}:

buildDunePackage rec {
	pname = "git";
	version = "2.1.3";

	minimumOCamlVersion = "4.07";
	useDune2 = true;

	src = fetchurl {
		url = "https://github.com/mirage/ocaml-git/releases/download/${version}/git-${version}.tbz";
		sha256 = "1ppllv65vrkfrmx46aiq5879isffcjmg92z9rv2kh92a83h4lqax";
	};

	propagatedBuildInputs = [
		angstrom astring checkseum cstruct decompress digestif encore duff fmt fpath
		hex ke logs lru ocaml_lwt ocamlgraph ocplib-endian uri rresult stdlib-shims
	];
	checkInputs = [ alcotest mtime mirage-crypto-rng tls git-binary ];
	doCheck = !stdenv.isAarch64;

	meta = with stdenv; {
		description = "Git format and protocol in pure OCaml";
		license = lib.licenses.isc;
		maintainers = [ lib.maintainers.vbgl ];
		homepage = "https://github.com/mirage/ocaml-git";
	};
}
