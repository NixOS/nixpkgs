{ buildDunePackage
, kafka
, lwt
, cmdliner
}:

buildDunePackage rec {
  pname = "kafka_lwt";

  inherit (kafka) version useDune2 src;

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [ kafka lwt ];

  meta = kafka.meta // {
    description = "OCaml bindings for Kafka, Lwt bindings";
  };
}
