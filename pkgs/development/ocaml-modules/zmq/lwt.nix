{ stdenv, buildDunePackage, zmq, ocaml_lwt }:

buildDunePackage rec {
  pname = "zmq-lwt";
  inherit (zmq) version src meta;

  propagatedBuildInputs = [ zmq ocaml_lwt ];
}
