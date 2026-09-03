{
  fetchurl,
  lib,
  newCatalog,
}:

newCatalog {
  name = "json-patch-schemastore";
  displayName = "JSON Patch as maintained by the https://www.schemastore.org community";
  version = "2024-11-26";
  groups = {
    "JSON Patch" = {
      "https://json.schemastore.org/json-patch.json" = fetchurl {
        name = "json-patch-schema";
        # Note that we don't use the json.schemastore.org URLs directly, as those are mutable resources.
        # Make sure to update the version above!
        url = "https://github.com/schemastore/schemastore/raw/138439cd4f9d7bf57d6747b674ce5bbcffbfafdc/src/schemas/json/json-patch.json";
        hash = "sha256-vrqlgvlU61aEO6jd1SLLEqJDZG1k+eTBozcyPmhUp2U=";
      };
    };
  };
  extraDescription = ''
    A JSON Patch is a sequence of editing and checking operations to perform against another JSON document.
    It is specified in IETF RFC 6902: https://datatracker.ietf.org/doc/html/rfc6902/

    The schema is maintained by the community at https://www.schemastore.org, which is a collection of JSON Schemas for various purposes.
  '';
  meta = {
    maintainers = with lib.maintainers; [ roberth ];
    license = lib.licenses.asl20;
    changelog = "https://github.com/schemastore/schemastore/commits/master/src/schemas/json/json-patch.json";
  };
}
