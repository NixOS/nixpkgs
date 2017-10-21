{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, qtest, ounit }:

let version = "0.4.0.1"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-gen-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "gen";
    rev = "${version}";
    sha256 = "0gg94f5l899rni3r7s7wq8plgazmbsaw498xckp25kkgpmkk61ml";
  };

  buildInputs = [ ocaml findlib ocamlbuild qtest ounit ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/c-cube/gen;
    description = "Simple, efficient iterators for OCaml";
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
  };
}
