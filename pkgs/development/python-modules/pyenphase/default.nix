{
  lib,
  awesomeversion,
  buildPythonPackage,
  envoy-utils,
  fetchFromGitHub,
  httpx,
  lxml,
  orjson,
  poetry-core,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  respx,
  syrupy,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pyenphase";
  version = "1.22.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "pyenphase";
    repo = "pyenphase";
    rev = "refs/tags/v${version}";
    hash = "sha256-letF0s/zJKdMT2nGnZpMFufja0bsL0zlwG+dCSK5BA4=";
  };

  pythonRelaxDeps = [ "tenacity" ];

  build-system = [ poetry-core ];

  dependencies = [
    awesomeversion
    envoy-utils
    httpx
    lxml
    orjson
    pyjwt
    tenacity
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
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
    changelog = "https://github.com/pyenphase/pyenphase/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
