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
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d23ebd5b71e541e031b02a19db10b5e6d5ef8452c552833e3e1afc836b40b1ad";
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
