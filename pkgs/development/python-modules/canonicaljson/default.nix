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
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4v2u8df63F2ctZvT0NQbBk3dppeAmsQyXc7XIdEvET8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    simplejson
  ];

  nativeCheckInputs = [
    pytestCheckHook
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
