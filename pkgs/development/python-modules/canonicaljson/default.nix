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
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qTZk9phVbb1Lq5w/xPs1g0zyU12h6gC2t3WNj+K7uCQ=";
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
