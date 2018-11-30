{ stdenv, fetchFromGitHub, ocaml, dune, findlib, ocamlbuild }:

let version = "1.4.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-bisect_ppx-ocamlbuild-${version}";

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
    ocamlbuild
  ];

  buildPhase = "dune build -p bisect_ppx-ocamlbuild";

  inherit (dune) installPhase;

  meta = {
    homepage = https://github.com/aantron/bisect_ppx;
    platforms = ocaml.meta.platforms or [];
    description = "Code coverage for OCaml";
    license = stdenv.lib.licenses.mpl20;
  };
}
