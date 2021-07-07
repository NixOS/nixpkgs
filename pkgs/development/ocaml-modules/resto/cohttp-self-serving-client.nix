{ lib
, buildDunePackage
, resto
, uri
, resto-cohttp-client
, resto-cohttp-server
, cohttp-lwt
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-self-serving-client";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    uri
    resto-cohttp-client
    resto-cohttp-server
    cohttp-lwt
    lwt
  ];
}
