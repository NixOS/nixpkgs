{ lib, fetchzip, stdenv, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-getopt";
  version = "20120615";

  src = fetchzip {
    url = "https://download.ocamlcore.org/ocaml-getopt/ocaml-getopt/${version}/ocaml-getopt-${version}.tar.gz";
    sha256 = "0bng2mmdixpmj23xn8krlnaq66k22iclwz46r8zjrsrq3wcn1xgn";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];

  strictDeps = true;

  doCheck = true;
  createFindlibDestdir = true;

  meta = {
    inherit (ocaml.meta) platforms;
    homepage = "https://github.com/gildor478/ocaml-getopt";
    description = "Parsing of command line arguments (similar to GNU GetOpt) for OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
