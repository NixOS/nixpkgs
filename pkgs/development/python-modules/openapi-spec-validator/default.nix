{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, setuptools

# propagates
, importlib-resources
, jsonschema
, jsonschema-spec
, lazy-object-proxy
, openapi-schema-validator
, pyyaml

# optional
, requests

# tests
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.5.1";
  format = "pyproject";

  # no tests via pypi sdist
  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = version;
    hash = "sha256-8VhD57dNG0XrPUdcq39GEfHUAgdDwJ8nv+Lp57OpTLg=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    importlib-resources
    jsonschema
    jsonschema-spec
    lazy-object-proxy
    openapi-schema-validator
    pyyaml
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
    maintainers = with maintainers; [ rvl ];
  };
}
