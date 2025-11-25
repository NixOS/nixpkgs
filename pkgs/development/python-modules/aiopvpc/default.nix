{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-timeout,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  python-dotenv,
}:

buildPythonPackage rec {
  pname = "aiopvpc";
  version = "4.3.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "azogue";
    repo = "aiopvpc";
    tag = "v${version}";
    hash = "sha256-1xeXfhoXRfJ7vrpRPeYmwcAGjL09iNCOm/f4pPvuZLU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytest-cov-stub
    pytestCheckHook
    python-dotenv
  ];

  pythonImportsCheck = [ "aiopvpc" ];

  meta = with lib; {
    description = "Python module to download Spanish electricity hourly prices (PVPC)";
    homepage = "https://github.com/azogue/aiopvpc";
    changelog = "https://github.com/azogue/aiopvpc/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
