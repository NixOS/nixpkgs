{
  lib,
  aiohttp-retry,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  parameterized,
  pycryptodome,
  pytest-aiohttp,
  pytest-asyncio_0,
  pytest-cov-stub,
  pytest-golden,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
  requests-mock,
  responses,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyrainbird";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "pyrainbird";
    tag = version;
    hash = "sha256-s4AZXhub1VM4zHvUnhBjmZREE0O3FcK27PPHLzCE2mU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp-retry
    ical
    mashumaro
    pycryptodome
    python-dateutil
    pyyaml
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    parameterized
    (pytest-aiohttp.override { pytest-asyncio = pytest-asyncio_0; })
    pytest-asyncio_0
    pytest-cov-stub
    pytest-golden
    pytest-mock
    pytestCheckHook
    requests-mock
    responses
  ];

  pythonImportsCheck = [ "pyrainbird" ];

  meta = {
    description = "Module to interact with Rainbird controllers";
    homepage = "https://github.com/allenporter/pyrainbird";
    changelog = "https://github.com/allenporter/pyrainbird/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
