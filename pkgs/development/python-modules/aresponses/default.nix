{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aresponses";
    repo = "aresponses";
    rev = version;
    hash = "sha256-RklXlIsbdq46/7D6Hv4mdskunqw1a7SFF09OjhrvMRY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pytest-asyncio
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disable tests which requires network access
    "test_foo"
    "test_passthrough"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aresponses" ];

  meta = with lib; {
    changelog = "https://github.com/aresponses/aresponses/blob/${src.rev}/README.md#changelog";
    description = "Asyncio testing server";
    homepage = "https://github.com/aresponses/aresponses";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
