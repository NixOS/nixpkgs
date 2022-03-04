{ lib, buildDunePackage, resto, uri }:

buildDunePackage {
  pname = "resto-acl";
  inherit (resto) src version meta doCheck;

    minimalOCamlVersion = "4.05";

  propagatedBuildInputs = [
    resto
    uri
  ];
}
