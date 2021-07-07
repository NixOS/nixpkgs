{ lib, buildDunePackage, resto, resto-directory, cohttp-lwt, resto-acl, }:

buildDunePackage {
  pname = "resto-cohttp";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto-directory
    cohttp-lwt
  ];

  checkInputs = [
    resto-acl
  ];
}
