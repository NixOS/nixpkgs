{ lib, buildDunePackage, json-data-encoding, ocplib-endian, crowbar }:

buildDunePackage {
  pname = "json-data-encoding-bson";

  inherit (json-data-encoding) version src useDune2 doCheck;

  propagatedBuildInputs = [
    json-data-encoding
    ocplib-endian
  ];

  checkInputs = [
    crowbar
  ];

  meta = json-data-encoding.meta // {
    description = "Type-safe encoding to and decoding from JSON (bson support)";
  };
}
