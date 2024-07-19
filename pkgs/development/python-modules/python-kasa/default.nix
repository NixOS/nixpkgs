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
  pydantic,
  pytest-asyncio,
  pytest-freezer,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "python-kasa";
  version = "0.7.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-kasa";
    repo = "python-kasa";
    rev = "refs/tags/${version}";
    hash = "sha256-MZgbHohp+QaTg7gdsIu3Q/4sLVqvtzDjmQScYSZO3Yw=";
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
    mainProgram = "kasa";
    homepage = "https://python-kasa.readthedocs.io/";
    changelog = "https://github.com/python-kasa/python-kasa/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
