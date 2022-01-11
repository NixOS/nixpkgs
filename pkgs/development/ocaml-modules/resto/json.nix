{ lib, buildDunePackage, resto, json-data-encoding, json-data-encoding-bson }:

buildDunePackage {
  pname = "resto-json";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    json-data-encoding
    json-data-encoding-bson
  ];
}
