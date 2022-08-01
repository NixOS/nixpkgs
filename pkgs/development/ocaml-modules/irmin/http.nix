{ lib, buildDunePackage, cohttp-lwt, cohttp-lwt-unix, irmin, webmachine
, checkseum, git-unix, irmin-git, irmin-test, digestif, astring
, cohttp, fmt, jsonm, logs, lwt, uri, cacert
}:

buildDunePackage rec {

  pname = "irmin-http";

  inherit (irmin) version src;

  useDune2 = true;

  propagatedBuildInputs = [
    cohttp-lwt
    irmin
    webmachine
    astring
    cohttp
    fmt
    jsonm
    logs
    lwt
    uri
    cacert
  ];

  checkInputs = [
    irmin-git irmin-test git-unix digestif cohttp-lwt-unix
  ];

  doCheck = true;

  meta = irmin.meta // {
    description = "HTTP client and server for Irmin";
  };

}


