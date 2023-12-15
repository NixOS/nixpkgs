{ lib
, anyio
, async-timeout
, asyncclick
, buildPythonPackage
, fetchFromGitHub
, kasa-crypt
, orjson
, poetry-core
, pydantic
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.5.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wGPMrYaTtKkkNW88eyiiciFcBSTRqqChYi6e15WUCHo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    anyio
    async-timeout
    asyncclick
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    voluptuous
  ];

  passthru.optional-dependencies = {
    speedup = [
      kasa-crypt
      orjson
    ];
  };

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
