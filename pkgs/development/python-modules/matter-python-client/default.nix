{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  orjson,
  home-assistant-chip-clusters,

  # tests
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "matter-python-client";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matter-js";
    repo = "matterjs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t53DeMfSSt9lyz1etfrojRHqGkjEUK/oZoCNbpyDvsk=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_client";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    home-assistant-chip-clusters
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  disabledTestPaths = [
    # requires npx and network access to start matterjs
    "tests/test_client_integration.py"
    "tests/test_integration.py"
  ];

  pythonImportsCheck = [
    "matter_server.client"
  ];

  meta = {
    changelog = "https://github.com/matter-js/matterjs-server/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python Client for the OHF Matter Server";
    homepage = "https://github.com/matter-js/matterjs-server/tree/main/python_client";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
})
