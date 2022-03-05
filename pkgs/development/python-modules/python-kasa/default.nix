{ lib
, asyncclick
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, poetry-core
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.4.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-4e9jpUDorZlKCYwWtqrba61zbkJl57oWUhEpFcaS9ak=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncclick
    importlib-metadata
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    voluptuous
  ];

  disabledTestPaths = [
    # Skip the examples tests
    "kasa/tests/test_readme_examples.py"
  ];

  pythonImportsCheck = [
    "kasa"
  ];

  meta = with lib; {
    description = "Python API for TP-Link Kasa Smarthome products";
    homepage = "https://python-kasa.readthedocs.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
