{ lib
, buildDunePackage
, resto
, resto-directory
, resto-acl
, resto-cohttp
, resto-cohttp-client
, resto-cohttp-server
, uri
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-self-serving-client";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    resto-directory
    resto-acl
    resto-cohttp
    resto-cohttp-client
    resto-cohttp-server
    uri
    lwt
  ];
}
