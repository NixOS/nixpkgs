{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# build-system
, poetry-core

# propagates
, importlib-resources
, jsonschema
, jsonschema-spec
, lazy-object-proxy
, openapi-schema-validator

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  # no tests via pypi sdist
  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-spec-validator";
    rev = "refs/tags/${version}";
    hash = "sha256-sGr4dH6Twyi4OeCAXZiboN75dYZ6wJ0pWMzV9zOfee0=";
  };

  postPatch = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    jsonschema-spec
    lazy-object-proxy
    openapi-schema-validator
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # network access
    "test_default_valid"
    "test_urllib_valid"
    "test_valid"
  ];

  pythonImportsCheck = [
    "openapi_spec_validator"
    "openapi_spec_validator.readers"
  ];

  meta = with lib; {
    changelog = "https://github.com/p1c2u/openapi-spec-validator/releases/tag/${version}";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    license = licenses.asl20;
  };
}
