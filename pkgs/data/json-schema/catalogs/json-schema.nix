{
  fetchurl,
  lib,
  newCatalog,
}:

newCatalog {
  name = "json-schema";
  displayName = "JSON Schema Metaschemas";
  groups = {
    "JSON Schema" = {
      "http://json-schema.org/draft-04/schema#" = fetchurl {
        name = "json-schema-draft-04";
        url = "https://json-schema.org/draft-04/schema";
        hash = "sha256-4UidC0dV8CeTMCWR0/y48Htok6gqlPJIlfjk7fEbguI=";
      };
      "http://json-schema.org/draft-06/schema#" = fetchurl {
        name = "json-schema-draft-06";
        url = "https://json-schema.org/draft-06/schema";
        hash = "sha256-AGTogLohS/8c7lEeZ4++SMmCbdNZ6R4kI/w23mey6+E=";
      };
      "http://json-schema.org/draft-07/schema#" = fetchurl {
        name = "json-schema-draft-07";
        url = "https://json-schema.org/draft-07/schema";
        hash = "sha256-aS4dFl5Hr8tfEbLOHGOWNf+oNANdbstrzzCHSB2uhAQ=";
      };
      # Unclear how newer metaschemas should be handled, so leaving them out for now.
      # https://github.com/roberth/json-schema-catalog-rs/issues/8
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ roberth ];
    # https://github.com/json-schema-org/json-schema-spec/blob/main/LICENSE
    license = [
      lib.licenses.bsd3
      lib.licenses.afl3
    ];
  };
}
