{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  aiohttp,
  yarl,
  aioresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiosolaredge";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiosolaredge";
    tag = "v${version}";
    hash = "sha256-1RdkYcdhhU+MaP91iJ1tSrL0OlUi6Il1XBXnmRYhC7g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "aiosolaredge" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/bdraco/aiosolaredge/blob/${src.tag}/CHANGELOG.md";
    description = "Asyncio SolarEdge API client";
    homepage = "https://github.com/bdraco/aiosolaredge";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
