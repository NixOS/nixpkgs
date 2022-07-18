{ lib, buildPythonPackage, isPy27, fetchPypi
, jsonschema, openapi-schema-validator, pyyaml, six, pathlib
, mock, pytest, pytest-cov, pytest-flake8, tox, setuptools
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l/JYhQr8l7BI98JlOFXg+I+masEDwr5Qd8eWCsoq1Jo=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ jsonschema openapi-schema-validator pyyaml six setuptools requests ]
    ++ (lib.optionals (isPy27) [ pathlib ]);

  checkInputs = [ mock pytest pytest-cov pytest-flake8 tox ];

  meta = with lib; {
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
