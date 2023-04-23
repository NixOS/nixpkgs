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
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vp2r842f9A2lEFLhUcHyGZavAWT4Ke9mH+FAlGucdqo=";
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
    changelog = "https://github.com/python-kasa/python-kasa/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
