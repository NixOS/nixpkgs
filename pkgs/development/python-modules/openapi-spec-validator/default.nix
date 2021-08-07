{ lib, buildPythonPackage, isPy27, fetchPypi
, jsonschema, openapi-schema-validator, pyyaml, six, pathlib
, mock, pytest, pytest-cov, pytest-flake8, tox, setuptools }:

buildPythonPackage rec {
  pname = "openapi-spec-validator";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d70e6592754799f7e77a45b98c6a91706bdd309a425169d17d8e92173e198a2";
  };

  propagatedBuildInputs = [ jsonschema openapi-schema-validator pyyaml six setuptools ]
    ++ (lib.optionals (isPy27) [ pathlib ]);

  checkInputs = [ mock pytest pytest-cov pytest-flake8 tox ];

  meta = with lib; {
    homepage = "https://github.com/p1c2u/openapi-spec-validator";
    description = "Validates OpenAPI Specs against the OpenAPI 2.0 (aka Swagger) and OpenAPI 3.0.0 specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ rvl ];
  };
}
