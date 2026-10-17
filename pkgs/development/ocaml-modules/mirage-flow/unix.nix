{
  buildDunePackage,
  fmt,
  logs,
  mirage-flow,
  lwt,
  cstruct,
  alcotest,
  mirage-flow-combinators,
}:

buildDunePackage {
  pname = "mirage-flow-unix";

  inherit (mirage-flow) version src;

  propagatedBuildInputs = [
    fmt
    logs
    mirage-flow
    lwt
    cstruct
  ];

  doCheck = true;
  checkInputs = [
    alcotest
    mirage-flow-combinators
  ];

  meta = mirage-flow.meta // {
    description = "Flow implementations and combinators for MirageOS on Unix";
  };
}
