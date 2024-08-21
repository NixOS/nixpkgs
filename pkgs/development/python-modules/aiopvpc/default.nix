{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-timeout,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-1xeXfhoXRfJ7vrpRPeYmwcAGjL09iNCOm/f4pPvuZLU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail " --cov --cov-report term --cov-report html" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
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
