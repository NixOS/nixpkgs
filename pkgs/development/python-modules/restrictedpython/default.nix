{ lib
, buildPythonPackage
, fetchPypi
, pytest-mock
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "restrictedpython";
  version = "7.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "RestrictedPython";
    inherit version;
    hash = "sha256-U3BK+7w1D9yPskVEE2e+Zxyfg4CGkgGy6EUudPzj2xQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
