{ lib, fetchurl, buildDunePackage, dune-configurator, czmq, stdint }:

buildDunePackage rec {
  pname = "zmq";
  version = "5.2.1";

  src = fetchurl {
    url = "https://github.com/issuu/ocaml-zmq/releases/download/${version}/zmq-${version}.tbz";
    hash = "sha256-hVKfaTrUFqEBsv5hFB7JwsR630M0DKnqhB0QHpxcHKc=";
  };

  buildInputs = [ czmq dune-configurator ];

  meta = {
    description = "ZeroMQ bindings for OCaml";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akavel ];
    homepage = "https://engineering.issuu.com/ocaml-zmq/";
  };
}
