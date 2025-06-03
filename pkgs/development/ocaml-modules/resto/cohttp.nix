{
  buildDunePackage,
  resto,
  resto-directory,
  cohttp-lwt,
}:

buildDunePackage {
  pname = "resto-cohttp";
  inherit (resto)
    src
    version
    meta
    doCheck
    ;
  duneVersion = "3";

  propagatedBuildInputs = [
    resto
    resto-directory
    cohttp-lwt
  ];
}
