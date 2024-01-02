{ buildDunePackage, irmin-mirage, irmin-git
, mirage-kv, cohttp, conduit-lwt, conduit-mirage
, git-paf, fmt, git, lwt, mirage-clock, uri
}:

buildDunePackage {
  pname = "irmin-mirage-git";

  inherit (irmin-mirage) version src strictDeps;
  duneVersion = "3";

  propagatedBuildInputs = [
    irmin-mirage
    irmin-git
    mirage-kv
    cohttp
    conduit-lwt
    conduit-mirage
    git-paf
    fmt
    git
    lwt
    mirage-clock
    uri
  ];

  inherit (irmin-mirage) meta;
}
