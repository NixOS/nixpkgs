{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ppx_derivers is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-ppx_derivers-${version}";
	version = "1.0";

	src = fetchFromGitHub {
		owner = "diml";
		repo = "ppx_derivers";
		rev = version;
		sha256 = "049yy9706lv1li6a1bibkz1qq2ixxbdyhf4f5w9pv71jc3dlpfy8";
	};

	buildInputs = [ ocaml findlib jbuilder ];

	inherit (jbuilder) installPhase;

	meta = {
		description = "Shared [@@deriving] plugin registry";
		license = stdenv.lib.licenses.bsd3;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
