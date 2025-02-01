{
  buildDunePackage,
  mirage-flow,
  lwt,
  logs,
  cstruct,
  mirage-clock,
}:

buildDunePackage {
  pname = "mirage-flow-combinators";

  inherit (mirage-flow) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    lwt
    logs
    cstruct
    mirage-clock
    mirage-flow
  ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS specialized to lwt";
  };
}
