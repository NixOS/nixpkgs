{
  lib,
  aiohttp,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  oauthlib,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  requests,
  requests-oauthlib,
  requests-mock,
  setuptools-scm,
  tenacity,
  time-machine,
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "9.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "pyatmo";
    tag = "v${version}";
    hash = "sha256-TJHCBGO9Pi3elewj4C9kIf4J9pyhSO5bYGONA3onvRE=";
  };

  pythonRelaxDeps = [
    "oauthlib"
    "requests-oauthlib"
    "requests"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    aiohttp
    oauthlib
    requests
    requests-oauthlib
    tenacity
  ];

  nativeCheckInputs = [
    anyio
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    requests-mock
    time-machine
  ];

  disabledTestPaths = [
    "tests/test_release_script.py"
  ];

  pythonImportsCheck = [ "pyatmo" ];

  meta = {
    description = "Simple API to access Netatmo weather station data";
    homepage = "https://github.com/jabesq/pyatmo";
    changelog = "https://github.com/jabesq/pyatmo/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
