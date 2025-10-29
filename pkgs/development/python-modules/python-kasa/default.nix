{
  lib,
  aiohttp,
  asyncclick,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  kasa-crypt,
  mashumaro,
  orjson,
  ptpython,
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
  version = "0.10.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "python-kasa";
    repo = "python-kasa";
    tag = version;
    hash = "sha256-OIkqNGTnIPoHYrE5NhAxSsRCTyMGvNADvIg28EuKsEw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
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

  pytestFlags = [ "--asyncio-mode=auto" ];

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
