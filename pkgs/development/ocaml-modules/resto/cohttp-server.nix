{ lib
, buildDunePackage
, resto
, resto-acl
, resto-directory
, resto-cohttp
, cohttp-lwt-unix
, conduit-lwt-unix
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-server";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto-directory
    resto-cohttp
    resto-acl
    cohttp-lwt-unix
    conduit-lwt-unix
    lwt
  ];
}
