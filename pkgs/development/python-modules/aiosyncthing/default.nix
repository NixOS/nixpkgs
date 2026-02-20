{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  deprecated,
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
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zhulik";
    repo = "aiosyncthing";
    tag = "v${version}";
    hash = "sha256-0jx61zs6yQqAIwSOO1zCUOkoZES+K/POtIGoWzr29bI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    deprecated
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

  meta = {
    description = "Python client for the Syncthing REST API";
    homepage = "https://github.com/zhulik/aiosyncthing";
    changelog = "https://github.com/zhulik/aiosyncthing/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
