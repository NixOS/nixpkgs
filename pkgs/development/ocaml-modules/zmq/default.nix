{ lib, fetchurl, buildDunePackage, dune-configurator, czmq, stdint }:

buildDunePackage rec {
  pname = "zmq";
  version = "5.1.5";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/issuu/ocaml-zmq/releases/download/${version}/zmq-lwt-${version}.tbz";
    sha256 = "sha256-mUfRPatLPFeSzWDwCIoFaVl85VkvDch4i6pOn3Kme1Y=";
  };

  buildInputs = [ czmq dune-configurator ];

  propagatedBuildInputs = [ stdint ];

  meta = {
    description = "ZeroMQ bindings for OCaml";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akavel ];
    homepage = "https://engineering.issuu.com/ocaml-zmq/";
  };
}
