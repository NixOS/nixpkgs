{ lib
, buildDunePackage
, resto
, resto-directory
, resto-acl
, resto-cohttp
, cohttp-lwt-unix
, conduit-lwt-unix
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-server";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    resto-directory
    resto-acl
    resto-cohttp
    cohttp-lwt-unix
    conduit-lwt-unix
    lwt
  ];
}
