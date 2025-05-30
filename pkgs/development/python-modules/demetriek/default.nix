{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "demetriek";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-demetriek";
    tag = "v${version}";
    hash = "sha256-KqLkct4Kd8wa5eKYJJq1y/5z5PbO0XaK0aGzs3bm8fs=";
  };

  postPatch = ''
    # Upstream doesn't set a version for the pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "demetriek" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python client for LaMetric TIME devices";
    homepage = "https://github.com/frenck/python-demetriek";
    changelog = "https://github.com/frenck/python-demetriek/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
