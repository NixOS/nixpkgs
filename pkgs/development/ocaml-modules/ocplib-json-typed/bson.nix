{ buildDunePackage, ocplib-json-typed, ocplib-endian }:

buildDunePackage {
  pname = "ocplib-json-typed-bson";
  inherit (ocplib-json-typed) version useDune2 src;

  propagatedBuildInputs = [ ocplib-json-typed ocplib-endian ];

  meta = {
    description = "A Json_repr compatible implementation of the JSON compatible subset of BSON";
    inherit (ocplib-json-typed.meta) homepage license maintainers;
  };
}
