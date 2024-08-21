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
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.6.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-CfSlF6DWkYxxVNTNBkr0+KVeKpqxEEqkz4VBenqo+l0=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    jsonschema
    jsonschema-specifications
    rfc3339-validator
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/python-openapi/openapi-schema-validator/issues/153
    "test_array_prefixitems_invalid"
  ];

  pytestFlagsArray = [ "-vvv" ];

  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
    changelog = "https://github.com/python-openapi/openapi-schema-validator/releases/tag/${version}";
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/python-openapi/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
