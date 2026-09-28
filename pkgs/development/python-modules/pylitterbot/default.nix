{
  lib,
  aiohttp,
  aiointercept,
  aioresponses,
  buildPythonPackage,
  deepdiff,
  fastmcp,
  fetchFromGitHub,
  hatchling,
  pycognito,
  pyjwt,
  pytest-aiohttp,
  pytest-cov-stub,
  pytest-freezegun,
  pytest-timeout,
  pytestCheckHook,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylitterbot";
  version = "2025.6.5";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    tag = finalAttrs.version;
    hash = "sha256-Rj7vRxrBnx0sghr4RO6KS1y5Sn21xe3ll0ai2hEY/eg=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiointercept
    aiohttp
    deepdiff
    fastmcp
    pycognito
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-cov-stub
    pytest-freezegun
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylitterbot" ];

  meta = {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
