{ buildDunePackage
, ocaml
, lib
, kafka
, lwt
, cmdliner
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "kafka_lwt is not available for OCaml ${ocaml.version}"

buildDunePackage rec {
  pname = "kafka_lwt";

  inherit (kafka) version src;

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [ kafka lwt ];

  meta = kafka.meta // {
    description = "OCaml bindings for Kafka, Lwt bindings";
  };
}
