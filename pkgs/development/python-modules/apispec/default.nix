{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pyyaml
, prance
, marshmallow
, pytestCheckHook
, mock
, openapi-spec-validator
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "4.7.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yf71c9nq1rfb5pkgmfw486fvywi1bjnmgwxcly7y3basf3980kr";
  };

  propagatedBuildInputs = [
    pyyaml
    prance
  ];

  checkInputs = [
    openapi-spec-validator
    marshmallow
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "apispec" ];

  meta = with lib; {
    description = "A pluggable API specification generator with support for the OpenAPI Specification";
    homepage = "https://github.com/marshmallow-code/apispec";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
