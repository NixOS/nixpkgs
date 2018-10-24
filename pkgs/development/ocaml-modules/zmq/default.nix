{ stdenv, fetchFromGitHub, ocaml, findlib, dune, czmq, stdint }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-zmq-${version}";
  version = "20180726";
  src = fetchFromGitHub {
    owner = "issuu";
    repo = "ocaml-zmq";
    rev = "d312a8458d6b688f75470248f11875fbbfa5bb1a";
    sha256 = "1f5l4bw78y4drabhyvmpj3z8k30bill33ca7bzhr02m55yf6gqpf";
  };

  patches = [
    ./ocaml-zmq-issue43.patch
  ];

  buildInputs = [ ocaml findlib dune czmq ];

  propagatedBuildInputs = [ stdint ];

  buildPhase = "dune build -p zmq";

  inherit (dune) installPhase;

  meta = with stdenv.lib; {
    description = "ZeroMQ bindings for OCaml";
    license     = licenses.mit;
    maintainers = with maintainers; [ akavel ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
