{ lib
, buildPythonPackage
, fetchFromGitHub
, frozendict
, pytestCheckHook
, pythonOlder
, simplejson
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.5.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
     owner = "matrix-org";
     repo = "python-canonicaljson";
     rev = "v1.5.0";
     sha256 = "0p8nr5b7cqdm1yr3gw3fv0jhidn6vv41v71j1hk8nm1nsk4g7n5m";
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
