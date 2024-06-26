{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  incremental,

  # tests
  aioresponses,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-socket,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "aioazuredevops";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aioazuredevops";
    rev = "refs/tags/${version}";
    hash = "sha256-QEIVAcBoTvuOeLN2kfDa3uYfrUm5Qu1TLp9C0uU+mW4=";
  };

  build-system = [
    incremental
    setuptools
  ];

  dependencies = [
    aiohttp
    incremental
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytest-socket
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [
    "aioazuredevops.builds"
    "aioazuredevops.client"
    "aioazuredevops.core"
  ];

  meta = with lib; {
    changelog = "https://github.com/timmo001/aioazuredevops/releases/tag/${version}";
    description = "Get data from the Azure DevOps API";
    mainProgram = "aioazuredevops";
    homepage = "https://github.com/timmo001/aioazuredevops";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
