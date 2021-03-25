{ buildDunePackage, irmin-mirage, irmin-graphql
, mirage-clock, cohttp-lwt, lwt, uri, git
}:

buildDunePackage {
  pname = "irmin-mirage-graphql";

  inherit (irmin-mirage) version src useDune2;

  propagatedBuildInputs = [
    irmin-mirage
    irmin-graphql
    mirage-clock
    cohttp-lwt
    lwt
    uri
    git
  ];

  inherit (irmin-mirage) meta;
}
