{ buildDunePackage
, resto
, resto-directory
, resto-cohttp
, uri
, lwt
}:

buildDunePackage {
  pname = "resto-cohttp-client";
  inherit (resto) src version meta doCheck;
  duneVersion = "3";

  propagatedBuildInputs = [
    resto
    resto-directory
    resto-cohttp
    uri
    lwt
  ];
}
