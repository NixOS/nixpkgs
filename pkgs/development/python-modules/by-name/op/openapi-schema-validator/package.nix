{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # propagates
  jsonschema,
  jsonschema-specifications,
  rfc3339-validator,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-schema-validator";
    tag = version;
    hash = "sha256-1Y049W4TbqvKZRwnvPVwyLq6CH6NQDrEfJknuMn8dGo=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    jsonschema
    jsonschema-specifications
    rfc3339-validator
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTests = [
    # https://github.com/python-openapi/openapi-schema-validator/issues/153
    "test_array_prefixitems_invalid"
  ];

  pytestFlags = [ "-vvv" ];

  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
    changelog = "https://github.com/python-openapi/openapi-schema-validator/releases/tag/${src.tag}";
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/python-openapi/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
