{ lib, buildPythonPackage, isPy27, fetchPypi
, jsonschema, pyyaml, six, pathlib
, mock, pytest, pytestcov, pytest-flake8, tox, setuptools }:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.2.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kav0jlgdpgwx4am09ja7cr8s1g8h8a7j8mcfy1cfjr8fficg2g4";
  };

  propagatedBuildInputs = [ jsonschema pyyaml six setuptools ]
    ++ (lib.optionals (isPy27) [ pathlib ]);

  checkInputs = [ mock pytest pytestcov pytest-flake8 tox ];

  meta = with lib; {
    homepage = https://github.com/p1c2u/openapi-spec-validator;
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
