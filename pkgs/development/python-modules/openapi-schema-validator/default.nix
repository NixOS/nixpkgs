{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, isodate
, jsonschema
, rfc3339-validator
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
  version = "0.4.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2XTCdp9dfzhNKCpq71pt7yEZm9abiEmFHD/114W+jOQ=";
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

  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/p1c2u/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
