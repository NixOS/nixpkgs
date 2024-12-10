{
  buildDunePackage,
  awa,
  cstruct,
  mtime,
  lwt,
  mirage-flow,
  mirage-clock,
  logs,
  duration,
  mirage-time,
}:

buildDunePackage {
  pname = "awa-mirage";

  inherit (awa) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    awa
    cstruct
    mtime
    lwt
    mirage-flow
    mirage-clock
    logs
    duration
    mirage-time
  ];

  inherit (awa) meta;
}
