{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  expects,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiosyncthing";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiosyncthing";
    tag = "v${version}";
    hash = "sha256-vn8S2/kRW5C2Hbes9oLM4LGm1jWWK0zeLdujR14y6EI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    expects
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
    pytest-mock
  ];

  pytestFlags = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "aiosyncthing" ];

  meta = with lib; {
    description = "Python client for the Syncthing REST API";
    homepage = "https://github.com/zhulik/aiosyncthing";
    changelog = "https://github.com/zhulik/aiosyncthing/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
