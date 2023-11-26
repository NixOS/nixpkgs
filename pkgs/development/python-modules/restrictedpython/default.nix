{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
}:

buildPythonPackage rec {
  pname = "restrictedpython";
  version = "6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "RestrictedPython";
    inherit version;
    hash = "sha256-23Prfjs5ZQ8NIdEMyN2pwOKYbmIclLDF3jL7De46CK8=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    "test_compile__compile_restricted_exec__5"
  ];

  pythonImportsCheck = [
    "RestrictedPython"
  ];

  meta = with lib; {
    description = "Restricted execution environment for Python to run untrusted code";
    homepage = "https://github.com/zopefoundation/RestrictedPython";
    changelog = "https://github.com/zopefoundation/RestrictedPython/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ juaningan ];
  };
}
