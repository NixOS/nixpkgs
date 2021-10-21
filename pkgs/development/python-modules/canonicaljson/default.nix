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
  version = "1.5.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Xr3c10xbBm7mjsylZGUzjpsTgEZ+CpBvR5dpfJ+zgeI=";
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
