{ lib, buildPythonPackage, isPy27, fetchPypi
, jsonschema, pyyaml, six, pathlib
, mock, pytest, pytestcov, pytest-flake8, tox, setuptools }:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53ba3d884e98ff2062d5ada025aa590541dcd665b8f81067dc82dd61c0923759";
  };

  propagatedBuildInputs = [ jsonschema pyyaml six setuptools ]
    ++ (lib.optionals (isPy27) [ pathlib ]);

  checkInputs = [ mock pytest pytestcov pytest-flake8 tox ];

  meta = with lib; {
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
