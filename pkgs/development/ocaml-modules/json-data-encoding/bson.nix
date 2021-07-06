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

  meta = {
    homepage = "https://gitlab.com/nomadic-labs/json-data-encoding";
    description = "Type-safe encoding to and decoding from JSON (bson support)";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
