{ lib
, buildPythonPackage
, fetchPypi
, frozendict
, pytestCheckHook
, pythonOlder
, setuptools
, simplejson
}:

buildPythonPackage rec {
  pname = "canonicaljson";
  version = "1.6.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bAmyEZUR8w6xEmz82XOhCCTiDxz9JQOc3j0SGN2cjY8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    simplejson
  ];

  passthru.optional-dependencies = {
    frozendict = [
      frozendict
    ];
  };

  nativeCheckInputs = [
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
