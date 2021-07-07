{ lib, buildDunePackage, resto, uri }:

buildDunePackage {
  pname = "resto-acl";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    uri
  ];
}
