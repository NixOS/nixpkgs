{
  json-schema,
  lib,
  json-schema-catalog-rs,
  runCommand,
}:

lib.recurseIntoAttrs {
  test-with-json-schema-catalog-rs =
    runCommand "json-schema-catalogs-integration-test"
      {
        nativeBuildInputs = [
          json-schema
          json-schema-catalog-rs
        ];
      }
      ''
        cat >example.json <<"EOF"
        {
          "$id": "https://example.com/schemas/integration-test.json",
          "$schema": "http://json-schema.org/draft-07/schema#",
          "title": "Integration Test",
          "type": "object"
        }
        EOF
        cat >example.json.expected <<"EOF"
        {
          "$id": "https://example.com/schemas/integration-test.json",
          "$schema": "${
            json-schema.internals.groups."JSON Schema"."http://json-schema.org/draft-07/schema#"
          }",
          "title": "Integration Test",
          "type": "object"
        }
        EOF

        json-schema-catalog replace --verbose example.json > example.json.out

        diff -U3 --color=always example.json.expected example.json.out
        touch $out
      '';
}
