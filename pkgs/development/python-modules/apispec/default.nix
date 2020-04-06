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
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "24b8490c22310b0779a058ccb24ec2fef33d571bb5aba1f525ab5963b0eabcdd";
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
