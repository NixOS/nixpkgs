{ lib, buildPythonPackage, isPy27, fetchPypi
, jsonschema, pyyaml, six, pathlib
, mock, pytest, pytestcov, pytest-flake8, tox }:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sz9ls6a7h056nc5q76w4xl43sr1h9in2f23qwkxazcazr3zpi3p";
  };

  propagatedBuildInputs = [ jsonschema pyyaml six ]
    ++ (lib.optionals (isPy27) [ pathlib ]);

  checkInputs = [ mock pytest pytestcov pytest-flake8 tox ];

  meta = with lib; {
    homepage = https://github.com/p1c2u/openapi-spec-validator;
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
