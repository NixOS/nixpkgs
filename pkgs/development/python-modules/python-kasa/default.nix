{
  lib,
  aiohttp,
  async-timeout,
  asyncclick,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  kasa-crypt,
  orjson,
  poetry-core,
  ptpython,
  pydantic,
  pytest-asyncio,
  pytest-freezer,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  rich,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.7.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-kasa";
    repo = "python-kasa";
    rev = "refs/tags/${version}";
    hash = "sha256-JfTFed591z1ZxTKP5FqYyaMBq8uCs4StlnqKp3Tc7Ug=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
    asyncclick
    cryptography
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-freezer
    pytest-mock
    pytestCheckHook
    voluptuous
  ];

  passthru.optional-dependencies = {
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
    "kasa/tests/test_readme_examples.py"
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
