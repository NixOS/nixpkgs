{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  tenacity,
  yarl,
}:

buildPythonPackage rec {
  pname = "demetriek";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-demetriek";
    tag = "v${version}";
    hash = "sha256-35hMOrpyINXOsPA09XnCNOwURLD5dIdhiYSJZDYCWJE=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    tenacity
    yarl
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "demetriek" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python client for LaMetric TIME devices";
    homepage = "https://github.com/frenck/python-demetriek";
    changelog = "https://github.com/frenck/python-demetriek/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
