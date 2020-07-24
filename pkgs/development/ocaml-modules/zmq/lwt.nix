{ buildDunePackage, zmq, ocaml_lwt }:

buildDunePackage {
  pname = "zmq-lwt";
  inherit (zmq) version src meta;

  propagatedBuildInputs = [ zmq ocaml_lwt ];
}
