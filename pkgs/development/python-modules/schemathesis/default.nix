{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  click,
  harfile,
  httpx,
  hypothesis,
  hypothesis-graphql,
  hypothesis-jsonschema,
  jsonschema-rs,
  junit-xml,
  pyrate-limiter,
  pytest,
  pyyaml,
  requests,
  rich,
  starlette-testclient,
  tenacity,
  tomli,
  typing-extensions,
  werkzeug,
}:

buildPythonPackage (finalAttrs: {
  pname = "schemathesis";
  version = "4.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-FfNIFmMEOPR7Pi+KcfIYHBAjqkWNQUMX4B/OQAAdAGY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    harfile
    httpx
    hypothesis
    hypothesis-graphql
    hypothesis-jsonschema
    jsonschema-rs
    junit-xml
    pyrate-limiter
    pytest
    pyyaml
    requests
    rich
    starlette-testclient
    tenacity
    typing-extensions
    werkzeug
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # Test suite requires `hypothesis-openapi` (not packaged) plus a large
  # network/property-based fixture set. Rely on the smoke check below.
  doCheck = false;

  pythonImportsCheck = [ "schemathesis" ];

  meta = {
    description = "Adaptive API testing for OpenAPI and GraphQL";
    homepage = "https://github.com/schemathesis/schemathesis";
    changelog = "https://github.com/schemathesis/schemathesis/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tembleking ];
    mainProgram = "schemathesis";
  };
})
