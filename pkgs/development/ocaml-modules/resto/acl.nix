{ lib, buildDunePackage, resto, uri }:

buildDunePackage {
  pname = "resto-acl";
  inherit (resto) src version meta doCheck;

  minimalOCamlVersion = "4.10";

  propagatedBuildInputs = [
    resto
    uri
  ];
}
