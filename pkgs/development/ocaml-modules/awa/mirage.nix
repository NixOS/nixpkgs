{
  buildDunePackage,
  awa,
  cstruct,
  mtime,
  lwt,
  mirage-flow,
  mirage-sleep,
  logs,
  duration,
  mirage-mtime,
}:

buildDunePackage {
  pname = "awa-mirage";

  inherit (awa) version src;

  propagatedBuildInputs = [
    awa
    cstruct
    mtime
    lwt
    mirage-flow
    mirage-sleep
    logs
    duration
    mirage-mtime
  ];

  inherit (awa) meta;
}
