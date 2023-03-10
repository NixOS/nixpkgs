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
  version = "1.6.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aN/BV7AR4H2Uv3S11MzAGVhYTtlC2d/V/dcGYJ6BzUs=";
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
    changelog = "https://github.com/matrix-org/python-canonicaljson/blob/v${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
