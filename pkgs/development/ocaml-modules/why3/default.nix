{ stdenv, ocaml, findlib, zarith, menhir, why3 }:

let ocaml-version = stdenv.lib.getVersion ocaml; in

assert stdenv.lib.versionAtLeast ocaml-version "4.01";

stdenv.mkDerivation {
  name = "ocaml-${why3.name}";

  inherit (why3) src;

  buildInputs = [ ocaml findlib zarith menhir ];

  installTargets = "install-lib";

  meta = {
    inherit (why3.meta) license homepage;
    platforms = ocaml.meta.platforms;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
