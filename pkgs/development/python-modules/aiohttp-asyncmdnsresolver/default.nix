{
  lib,
  aiodns,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "aiohttp-asyncmdnsresolver";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-asyncmdnsresolver";
    rev = "v${version}";
    hash = "sha256-z0m8dlzl6mglTOW9BwLbFcRjxcF14yz8+SE8SqjNu+c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiodns
    aiohttp
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_asyncmdnsresolver" ];

  meta = {
    description = "Module to resolve mDNS with aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp-asyncmdnsresolver";
    changelog = "https://github.com/aio-libs/aiohttp-asyncmdnsresolver/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
