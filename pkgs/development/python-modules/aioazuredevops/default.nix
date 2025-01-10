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
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aioazuredevops";
    rev = "refs/tags/${version}";
    hash = "sha256-1v58I9WOyyrp9n+qdvVeMZ3EObqP/06XCOZYS0nEvPU=";
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

  pythonImportsCheck = [ "aioazuredevops" ];

  meta = with lib; {
    changelog = "https://github.com/timmo001/aioazuredevops/releases/tag/${version}";
    description = "Get data from the Azure DevOps API";
    homepage = "https://github.com/timmo001/aioazuredevops";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
