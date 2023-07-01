{ lib
, buildPythonPackage
, fetchFromGitHub
, isodate
, jsonschema
, poetry-core
, pytestCheckHook
, pythonOlder
, rfc3339-validator
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-uFvM1EXN8wgk972YpQ52T4CkTWeF35ykF61EmFgblpk=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
    rfc3339-validator
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "openapi_schema_validator"
  ];

  meta = with lib; {
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/p1c2u/openapi-schema-validator";
    changelog = "https://github.com/python-openapi/openapi-schema-validator/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
