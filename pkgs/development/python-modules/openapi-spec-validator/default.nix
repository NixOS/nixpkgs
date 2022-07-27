{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core

# propagates
, jsonschema
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
  version = "0.4.0";
  format = "pyproject";

  # no tests via pypi sdist
  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = version;
    hash = "sha256-mGgHlDZTUo72RNZ/448gkGdza4EntYU9YoBpSKDUCeA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'openapi-schema-validator = "^0.2.0"' 'openapi-schema-validator = "*"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    openapi-schema-validator
    pyyaml
  ];

  passthru.optional-dependencies.requests = [
    requests
  ];

  preCheck = ''
    sed -i '/--cov/d' pyproject.toml
  '';

  checkInputs = [
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
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
