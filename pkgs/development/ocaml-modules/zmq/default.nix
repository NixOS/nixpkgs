{ stdenv, fetchFromGitHub, buildDunePackage, czmq, stdint }:

buildDunePackage rec {
  pname = "zmq";
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

  buildInputs = [ czmq ];
  propagatedBuildInputs = [ stdint ];

  meta = with stdenv.lib; {
    description = "ZeroMQ bindings for OCaml";
    license     = licenses.mit;
    maintainers = with maintainers; [ akavel ];
    inherit (src.meta) homepage;
  };
}
