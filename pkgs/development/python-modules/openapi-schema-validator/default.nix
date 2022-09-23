{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, isodate
, jsonschema
, pytest-cov
, rfc3339-validator
, six
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Ms00nR3dpJ0hGtHvVa5B29dasYtBP8igxrgMm0NiArc=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [ isodate jsonschema six strict-rfc3339 rfc3339-validator ];

  checkInputs = [ pytestCheckHook pytest-cov ];
  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/p1c2u/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
