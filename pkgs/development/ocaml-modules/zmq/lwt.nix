{ buildDunePackage, zmq, ocaml_lwt }:

buildDunePackage {
  pname = "zmq-lwt";
  inherit (zmq) version src useDune2 meta;

  propagatedBuildInputs = [ zmq ocaml_lwt ];
}
