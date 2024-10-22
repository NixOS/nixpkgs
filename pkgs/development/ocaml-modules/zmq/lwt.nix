{ buildDunePackage, zmq, lwt }:

buildDunePackage {
  pname = "zmq-lwt";
  inherit (zmq) version src meta;

  propagatedBuildInputs = [ zmq lwt ];
}
