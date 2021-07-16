{ lib, stdenv, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation {
  pname = "getopt";
  version = "20120615";

  src = builtins.fetchurl {
    url = https://download.ocamlcore.org/ocaml-getopt/ocaml-getopt/20120615/ocaml-getopt-20120615.tar.gz;
    sha256 = "1rz2mi3gddwpd249bvz6h897swiajk4d6cczrsscibwpkmdvrfwa";
  };

  buildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];

  doCheck = true;
  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/gildor478/ocaml-getopt";
    description = "Parsing of command line arguments (similar to GNU GetOpt) for OCaml";
    licence = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
