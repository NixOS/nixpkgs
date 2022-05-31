{ buildDunePackage, awa
, cstruct, mtime, lwt, mirage-flow, mirage-clock, mirage-time, logs
}:

buildDunePackage {
  pname = "awa-mirage";

  inherit (awa) version src useDune2;

  propagatedBuildInputs = [
    awa cstruct mtime lwt mirage-flow mirage-clock mirage-time logs
  ];

  inherit (awa) meta;
}
