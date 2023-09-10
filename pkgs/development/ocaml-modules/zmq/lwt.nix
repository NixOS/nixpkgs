{ buildDunePackage, zmq, ocaml_lwt }:

buildDunePackage {
  pname = "zmq-lwt";
  inherit (zmq) version src meta;
  duneVersion = "3";

  propagatedBuildInputs = [ zmq ocaml_lwt ];
}
