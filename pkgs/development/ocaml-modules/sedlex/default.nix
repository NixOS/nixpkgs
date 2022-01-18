{ stdenv, lib, fetchFromGitHub, ocaml, findlib, gen, ppx_tools_versioned, ocaml-migrate-parsetree }:

if !lib.versionAtLeast ocaml.version "4.02"
then throw "sedlex is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-sedlex";
  version = "1.99.5";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "sedlex";
    rev = "fb84e1766fc4b29e79ec40029ffee5cdb37b392f";
    sha256 = "sha256-VhzlDTYBFXgKWT69PqZYLuHkiaDwzhmyX2XfaqzHFl4=";
  };

  buildInputs = [ ocaml findlib ];

  propagatedBuildInputs = [ gen ocaml-migrate-parsetree ppx_tools_versioned ];

  buildFlags = [ "all" "opt" ];

  createFindlibDestdir = true;

  dontStrip = true;

  meta = {
    homepage = "https://github.com/ocaml-community/sedlex";
    description = "An OCaml lexer generator for Unicode";
    license = lib.licenses.mit;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
