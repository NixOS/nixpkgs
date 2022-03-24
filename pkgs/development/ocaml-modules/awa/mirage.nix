{ buildDunePackage, awa
, cstruct, mtime, lwt, mirage-flow, mirage-clock, logs
, mirage-time, duration
}:

buildDunePackage {
  pname = "awa-mirage";

  inherit (awa) version src useDune2;

  propagatedBuildInputs = [
    awa cstruct mtime lwt mirage-flow mirage-clock logs mirage-time duration
  ];

  inherit (awa) meta;
}
