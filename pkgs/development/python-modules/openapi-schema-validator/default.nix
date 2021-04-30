{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, isodate
, jsonschema
, pytest-flake8
, pytestcov
, rfc3339-validator
, six
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4b2712020284cee880b4c55faa513fbc2f8f07f365deda6098f8ab943c9f0df";
  };

  propagatedBuildInputs = [ isodate jsonschema six strict-rfc3339 rfc3339-validator ];

  checkInputs = [ pytestCheckHook pytestcov pytest-flake8 ];
  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/p1c2u/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
