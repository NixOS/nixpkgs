{
  buildDunePackage,
  mirage-flow,
  lwt,
  logs,
  cstruct,
  mirage-mtime,
}:

buildDunePackage {
  pname = "mirage-flow-combinators";

  inherit (mirage-flow) version src;

  propagatedBuildInputs = [
    lwt
    logs
    cstruct
    mirage-mtime
    mirage-flow
  ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS specialized to lwt";
  };
}
