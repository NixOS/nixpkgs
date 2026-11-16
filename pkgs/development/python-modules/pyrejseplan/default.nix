{
  lib,
  aiohttp,
  build,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic-xml,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools-scm,
  setuptools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrejseplan";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jawar19";
    repo = "pyRejseplan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-upfIXTzyMryIcLyKNWJyxsnko19PthAtOCjsWqFWnqE=";
  };

  build-system = [
    build
    setuptools
    setuptools-scm
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  dependencies = [
    aiohttp
    pydantic-xml
    requests
    urllib3
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Require network access and an API key.
    "TestDeparturesAPIClientBasic"
    "test_get_departures_legacy_fixture"
  ];

  pythonImportsCheck = [ "py_rejseplan" ];

  meta = {
    description = "Python interface with Rejseplanen's API 2.0 based on HAFAS";
    homepage = "https://github.com/Jawar19/pyRejseplan";
    changelog = "https://github.com/Jawar19/pyRejseplan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "pyRejseplan";
  };
})
