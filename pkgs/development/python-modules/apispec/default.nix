{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, mock
, openapi-spec-validator
, prance
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "5.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bqZULh6//p/ZW6Ae8/UTUerGwgCpdFYsdHMFm5zSCqc=";
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

  pythonImportsCheck = [
    "apispec"
  ];

  meta = with lib; {
    description = "A pluggable API specification generator with support for the OpenAPI Specification";
    homepage = "https://github.com/marshmallow-code/apispec";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
