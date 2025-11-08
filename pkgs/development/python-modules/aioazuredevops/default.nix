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
  version = "2.2.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aioazuredevops";
    tag = version;
    hash = "sha256-0KQHL9DmNeRvEs51XPcncxNzXb+SqYM5xPDvOdKSQMI=";
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

  disabledTests = [
    # https://github.com/timmo001/aioazuredevops/issues/44
    "test_get_project"
    "test_get_builds"
    "test_get_build"
  ];

  disabledTestPaths = [
    # https://github.com/timmo001/aioazuredevops/commit/d6278d92937dd47de272ac6371b2d007067763c3
    "tests/test__version.py"
  ];

  pytestFlags = [ "--snapshot-update" ];

  pythonImportsCheck = [ "aioazuredevops" ];

  meta = with lib; {
    changelog = "https://github.com/timmo001/aioazuredevops/releases/tag/${version}";
    description = "Get data from the Azure DevOps API";
    homepage = "https://github.com/timmo001/aioazuredevops";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
