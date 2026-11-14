{
  lib,
  aiohttp,
  aiohttp-retry,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  ical,
  mashumaro,
  parameterized,
  pycryptodome,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-golden,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyrainbird";
  version = "6.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "pyrainbird";
    tag = finalAttrs.version;
    hash = "sha256-yJ1Sg3gTu/0ACBLd0sAYVfbMR8vNv1a5QzWiSGFoS6c=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "aiohttp"
  ];

  dependencies = [
    aiohttp
    aiohttp-retry
    ical
    mashumaro
    pycryptodome
    python-dateutil
    pyyaml
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    freezegun
    parameterized
    pytest-aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytest-golden
    pytest-mock
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pyrainbird" ];

  meta = {
    description = "Module to interact with Rainbird controllers";
    homepage = "https://github.com/allenporter/pyrainbird";
    changelog = "https://github.com/allenporter/pyrainbird/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
