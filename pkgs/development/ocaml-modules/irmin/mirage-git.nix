{ buildDunePackage, irmin-mirage, irmin-git
, mirage-kv, cohttp, conduit-lwt, conduit-mirage
, git-cohttp-mirage, fmt, git, lwt, mirage-clock, uri
}:

buildDunePackage {
  pname = "irmin-mirage-git";

  inherit (irmin-mirage) version src useDune2;

  propagatedBuildInputs = [
    irmin-mirage
    irmin-git
    mirage-kv
    cohttp
    conduit-lwt
    conduit-mirage
    git-cohttp-mirage
    fmt
    git
    lwt
    mirage-clock
    uri
  ];

  inherit (irmin-mirage) meta;
}
