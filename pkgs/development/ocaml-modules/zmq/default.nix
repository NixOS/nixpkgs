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

  meta = with lib; {
    description = "ZeroMQ bindings for OCaml";
    license = licenses.mit;
    maintainers = with maintainers; [ akavel ];
    homepage = "https://engineering.issuu.com/ocaml-zmq/";
  };
}
