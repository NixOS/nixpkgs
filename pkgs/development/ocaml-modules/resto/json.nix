{ lib, buildDunePackage, resto, json-data-encoding, json-data-encoding-bson }:

buildDunePackage {
  pname = "resto-json";
  inherit (resto) src version meta doCheck;

  propagatedBuildInputs = [
    resto
    json-data-encoding
    json-data-encoding-bson
  ];
}
