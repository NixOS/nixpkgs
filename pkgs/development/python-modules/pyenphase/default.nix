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

buildPythonPackage rec {
  pname = "pyenphase";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyenphase";
    repo = "pyenphase";
    tag = "v${version}";
    hash = "sha256-WpfiRACZ08M9EQbjfM5dNz2cFFGd7OlG/SB6F128Rcs=";
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

  meta = with lib; {
    description = "Library to control enphase envoy";
    homepage = "https://github.com/pyenphase/pyenphase";
    changelog = "https://github.com/pyenphase/pyenphase/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
