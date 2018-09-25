{ stdenv, fetchFromGitHub, ocaml, findlib, dune }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ppx_derivers is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-ppx_derivers-${version}";
	version = "1.2";

	src = fetchFromGitHub {
		owner = "diml";
		repo = "ppx_derivers";
		rev = version;
		sha256 = "0bnhihl1w31as5w2czly1v3d6pbir9inmgsjg2cj6aaj9v1dzd85";
	};

	buildInputs = [ ocaml findlib dune ];

	inherit (dune) installPhase;

	meta = {
		description = "Shared [@@deriving] plugin registry";
		license = stdenv.lib.licenses.bsd3;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
