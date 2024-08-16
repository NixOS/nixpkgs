{ buildDunePackage, json-data-encoding, ocplib-endian, crowbar, alcotest }:

buildDunePackage {
  pname = "json-data-encoding-bson";

  inherit (json-data-encoding) version src doCheck;

  propagatedBuildInputs = [
    json-data-encoding
    ocplib-endian
  ];

  checkInputs = [
    crowbar
    alcotest
  ];

  meta = json-data-encoding.meta // {
    description = "Type-safe encoding to and decoding from JSON (bson support)";
  };
}
