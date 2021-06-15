{ buildDunePackage, awa
, cstruct, mtime, lwt, mirage-flow, mirage-clock, logs
}:

buildDunePackage {
  pname = "awa-mirage";

  inherit (awa) version src useDune2;

  propagatedBuildInputs = [
    awa cstruct mtime lwt mirage-flow mirage-clock logs
  ];

  inherit (awa) meta;
}
