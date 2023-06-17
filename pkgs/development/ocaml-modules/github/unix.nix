{ lib, buildDunePackage, github
, cohttp, cohttp-lwt-unix, stringext, cmdliner, lwt
}:

buildDunePackage {
  pname = "github-unix";
  inherit (github) version src;

  duneVersion = "3";

  propagatedBuildInputs = [
    github
    cohttp
    cohttp-lwt-unix
    stringext
    cmdliner
    lwt
  ];

  meta = github.meta // {
    description = "GitHub APIv3 Unix library";
  };
}
