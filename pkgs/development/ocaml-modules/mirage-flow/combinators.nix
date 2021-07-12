{ buildDunePackage, mirage-flow, fmt, ocaml_lwt, logs, cstruct, mirage-clock }:

buildDunePackage {
  pname = "mirage-flow-combinators";

  inherit (mirage-flow) version useDune2 src;

  propagatedBuildInputs = [ ocaml_lwt logs cstruct mirage-clock mirage-flow ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS specialized to lwt";
  };
}
