{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  envoy-utils,
  fetchFromGitHub,
  lxml,
  orjson,
  poetry-core,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  python-jsonpath,
  respx,
  syrupy,
  tenacity,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyenphase";
  version = "2.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyenphase";
    repo = "pyenphase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BMzYo6KrgJII/30TJndYRGOjRS2ufWJirQd5X8D0bbo=";
  };

  pythonRelaxDeps = [ "tenacity" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    envoy-utils
    lxml
    orjson
    pyjwt
    tenacity
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
    python-jsonpath
    respx
    syrupy
  ];

  disabledTestPaths = [
    # Tests need network access
    "tests/test_retries.py"
  ];

  pythonImportsCheck = [ "pyenphase" ];

  meta = {
    description = "Library to control enphase envoy";
    homepage = "https://github.com/pyenphase/pyenphase";
    changelog = "https://github.com/pyenphase/pyenphase/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
