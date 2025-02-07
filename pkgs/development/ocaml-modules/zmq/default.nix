{
  lib,
  fetchurl,
  buildDunePackage,
  dune-configurator,
  czmq,
}:

buildDunePackage rec {
  pname = "zmq";
  version = "5.3.0";

  src = fetchurl {
    url = "https://github.com/issuu/ocaml-zmq/releases/download/${version}/zmq-${version}.tbz";
    hash = "sha256-tetCmVg27/WHZ+HMwKZVHCrHTzWAlKwkAjNDibB1+6g=";
  };

  buildInputs = [
    czmq
    dune-configurator
  ];

  meta = {
    description = "ZeroMQ bindings for OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akavel ];
    homepage = "https://engineering.issuu.com/ocaml-zmq/";
  };
}
