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
  version = "4.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v6G+yLWyzqZyfgIMOm/hHZYwiN0u1hbhFHXOry1naTc=";
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
