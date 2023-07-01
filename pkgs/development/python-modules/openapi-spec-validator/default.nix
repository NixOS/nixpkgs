{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, importlib-resources
, jsonschema
, jsonschema-spec
, lazy-object-proxy
, openapi-schema-validator
, pyyaml
, requests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.5.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-BIGHaZhrEc7wcIesBIXdVRzozllCNOz67V+LmQfZ8oY=";
  };

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

  passthru.optional-dependencies.requests = [
    requests
  ];

  preCheck = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test require network access
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
    maintainers = with maintainers; [ rvl ];
  };
}
