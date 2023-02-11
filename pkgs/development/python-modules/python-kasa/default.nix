{ lib
, asyncclick
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, pydantic
, poetry-core
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-9zCUYB+TYgDMoTHpR0u42Usq2EKp8vtzlTgU82eXxl8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    asyncclick
    importlib-metadata
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    voluptuous
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
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
