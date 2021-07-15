{ buildDunePackage
, resto
, resto-directory
, resto-cohttp
, uri
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-client";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    resto-directory
    resto-cohttp
    uri
    lwt
  ];
}
