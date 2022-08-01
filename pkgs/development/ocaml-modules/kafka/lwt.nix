{ buildDunePackage
, kafka
, lwt
, cmdliner_1_1
}:

buildDunePackage rec {
  pname = "kafka_lwt";

  inherit (kafka) version useDune2 src;

  buildInputs = [ cmdliner_1_1 ];

  propagatedBuildInputs = [ kafka lwt ];

  meta = kafka.meta // {
    description = "OCaml bindings for Kafka, Lwt bindings";
  };
}
