{ stdenv, ocaml, findlib, dune, zmq, ocaml_lwt }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-zmq-lwt-${version}";
  inherit (zmq) version src installPhase meta;

  buildInputs = [ ocaml findlib dune ];

  propagatedBuildInputs = [ zmq ocaml_lwt ];

  buildPhase = "dune build -p zmq-lwt";
}
