{
  buildDunePackage,
  ocaml,
  lib,
  kafka,
  lwt,
  cmdliner_1,
}:

buildDunePackage {
  pname = "kafka_lwt";

  inherit (kafka) version src;

  buildInputs = [ cmdliner_1 ];

  propagatedBuildInputs = [
    kafka
    lwt
  ];

  meta = kafka.meta // {
    description = "OCaml bindings for Kafka, Lwt bindings";
    broken = lib.versionAtLeast ocaml.version "5.0";
  };
}
