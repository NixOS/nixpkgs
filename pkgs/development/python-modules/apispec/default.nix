{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, prance
, marshmallow
, pytest
, mock
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11d1aaf620a80f67ded7688fcaf14fa4fd975d566876b5db69b067ffbfe4d1d9";
  };

  checkInputs = [
    pyyaml
    prance
    openapi-spec-validator
    marshmallow
    pytest
    mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "A pluggable API specification generator. Currently supports the OpenAPI Specification (f.k.a. the Swagger specification";
    homepage = https://github.com/marshmallow-code/apispec;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
