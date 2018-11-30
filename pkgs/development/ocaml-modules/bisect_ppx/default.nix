{ stdenv, fetchFromGitHub, ocaml, dune, findlib, ocaml-migrate-parsetree, ppx_tools_versioned }:

let version = "1.4.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-bisect_ppx-${version}";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = "bisect_ppx";
    rev = version;
    sha256 = "1plhm4pvrhpapz5zaks194ji1fgzmp13y942g10pbn9m7kgkqg4h";
  };

  buildInputs = [
    ocaml
    dune
    findlib
    ocaml-migrate-parsetree
    ppx_tools_versioned
  ];

  buildPhase = "dune build -p bisect_ppx";

  inherit (dune) installPhase;

  meta = {
    homepage = https://github.com/aantron/bisect_ppx;
    platforms = ocaml.meta.platforms or [];
    description = "Code coverage for OCaml";
    license = stdenv.lib.licenses.mpl20;
  };
}
