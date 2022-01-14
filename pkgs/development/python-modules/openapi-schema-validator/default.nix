{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, isodate
, jsonschema
, pytest-flake8
, pytest-cov
, rfc3339-validator
, six
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71889d1cb69d9fb46eb04243b24e9c0cd7989d9153d29d8770e626874bf68f80";
  };

  propagatedBuildInputs = [ isodate jsonschema six strict-rfc3339 rfc3339-validator ];

  checkInputs = [ pytestCheckHook pytest-cov pytest-flake8 ];
  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/p1c2u/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
