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
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aioazuredevops";
    rev = "refs/tags/${version}";
    hash = "sha256-RZBiFPzYtEoc51T3irVHL9xVlZgACyM2lu1TkMoatqU=";
  };

  postPatch = ''
    substituteInPlace requirements_setup.txt \
      --replace-fail "==" ">="
  '';

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

  pytestFlagsArray = [ "--snapshot-update" ];

  pythonImportsCheck = [ "aioazuredevops" ];

  meta = with lib; {
    changelog = "https://github.com/timmo001/aioazuredevops/releases/tag/${version}";
    description = "Get data from the Azure DevOps API";
    homepage = "https://github.com/timmo001/aioazuredevops";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
