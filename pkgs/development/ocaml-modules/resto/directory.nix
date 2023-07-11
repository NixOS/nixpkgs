{ lib, buildDunePackage, resto, resto-json, lwt }:

buildDunePackage {
  pname = "resto-directory";
  inherit (resto) src version meta doCheck;
  duneVersion = "3";

  propagatedBuildInputs = [
    resto
    lwt
  ];
}
