{ lib, buildDunePackage, resto, resto-json, lwt }:

buildDunePackage {
  pname = "resto-directory";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    lwt
  ];
}
