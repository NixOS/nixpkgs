{ lib, buildDunePackage, resto, resto-json, lwt }:

buildDunePackage {
  pname = "resto-directory";
  inherit (resto) src version meta doCheck;

  propagatedBuildInputs = [
    resto
    lwt
  ];
}
