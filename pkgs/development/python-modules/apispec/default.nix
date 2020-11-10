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
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f5244ccca33f7a81309f6b3c9d458e33e869050c2d861b9f8cee24b3ad739d2b";
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
    homepage = "https://github.com/marshmallow-code/apispec";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
