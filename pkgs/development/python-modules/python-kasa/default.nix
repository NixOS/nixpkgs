{
  lib,
  aiohttp,
  async-timeout,
  asyncclick,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  kasa-crypt,
  orjson,
  ptpython,
  mashumaro,
  pytest-asyncio,
  pytest-freezer,
  pytest-mock,
  pytest-socket,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  rich,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "python-kasa";
    repo = "python-kasa";
    rev = "refs/tags/${version}";
    hash = "sha256-z4MBH4fBiR996/0nCsCkRYBD0+bd+NowJLR1ee2hr4Y=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    async-timeout
    asyncclick
    cryptography
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-freezer
    pytest-mock
    pytest-socket
    pytest-xdist
    pytestCheckHook
    voluptuous
  ];

  optional-dependencies = {
    shell = [
      ptpython
      rich
    ];
    speedups = [
      kasa-crypt
      orjson
    ];
  };

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  disabledTestPaths = [
    # Skip the examples tests
    "tests/test_readme_examples.py"
  ];

  pythonImportsCheck = [ "kasa" ];

  meta = with lib; {
    description = "Python API for TP-Link Kasa Smarthome products";
    homepage = "https://python-kasa.readthedocs.io/";
    changelog = "https://github.com/python-kasa/python-kasa/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
    mainProgram = "kasa";
  };
}
