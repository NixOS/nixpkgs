{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "5.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "marshmallow-code";
     repo = "apispec";
     rev = "5.1.1";
     sha256 = "0awcp4mb6q3cka86yw8cc5bzbwzs3c45yb36nlfjd3cnccv9vjzw";
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
