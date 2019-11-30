{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, prance
, marshmallow
, pytestCheckHook
, mock
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rr32z9hbf8w4w1fs5gj2v0ixcq2vq7a3wssrlxagi5ii7ygap7y";
  };

  checkInputs = [
    pyyaml
    prance
    openapi-spec-validator
    marshmallow
    mock
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A pluggable API specification generator. Currently supports the OpenAPI Specification (f.k.a. the Swagger specification";
    homepage = https://github.com/marshmallow-code/apispec;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
