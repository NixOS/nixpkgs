{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  deepdiff,
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
  version = "2025.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    tag = finalAttrs.version;
    hash = "sha256-k10QYIdV8EFGR/366IZ6OaXbK+kEcaz3Awdwu116zHA=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    deepdiff
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
