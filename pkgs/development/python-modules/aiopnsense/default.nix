{
  lib,
  aiohttp,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopnsense";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "Snuffy2";
    repo = "aiopnsense";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ffp0CTYqqeeB8462luTvpa2dp2QOxztkipretBqaKig=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    awesomeversion
    python-dateutil
  ];

  nativeCheckInputs = [
    aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopnsense" ];

  meta = {
    description = "Async Python client library for OPNsense";
    homepage = "https://github.com/Snuffy2/aiopnsense";
    changelog = "https://github.com/Snuffy2/aiopnsense/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
