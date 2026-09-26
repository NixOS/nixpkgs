{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio_0,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aresponses";
    repo = "aresponses";
    rev = version;
    hash = "sha256-RklXlIsbdq46/7D6Hv4mdskunqw1a7SFF09OjhrvMRY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pytest-asyncio_0
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disable tests which requires network access
    "test_foo"
    "test_passthrough"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aresponses" ];

  meta = {
    changelog = "https://github.com/aresponses/aresponses/blob/${src.rev}/README.md#changelog";
    description = "Asyncio testing server";
    homepage = "https://github.com/aresponses/aresponses";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ makefu ];
  };
}
