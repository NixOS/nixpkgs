{ buildDunePackage
, resto
, resto-cohttp
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
}
