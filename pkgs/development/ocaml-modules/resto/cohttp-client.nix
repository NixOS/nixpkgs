{ lib
, buildDunePackage
, resto
, resto-directory
, resto-cohttp
, resto-cohttp-self-serving-client
, resto-cohttp-server
, ezresto-directory
, uri
, cohttp-lwt
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-client";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    uri
    resto-cohttp
    cohttp-lwt
    lwt
  ];

  checkInputs = [
    resto-cohttp-server
    ezresto-directory
    # resto-cohttp-self-serving-client
  ];
}
