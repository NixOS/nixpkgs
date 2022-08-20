{ lib
, buildPythonPackage
, fetchPypi
, frozendict
, pytestCheckHook
, pythonOlder
, simplejson
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rwC+jOnFiYV98Xa7lFlPDUOw4CfwJ6jXz4l4/bgZAko=";
  };

  propagatedBuildInputs = [
    frozendict
    simplejson
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_frozen_dict"
  ];

  pythonImportsCheck = [
    "canonicaljson"
  ];

  meta = with lib; {
    description = "Encodes objects and arrays as RFC 7159 JSON";
    homepage = "https://github.com/matrix-org/python-canonicaljson";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
