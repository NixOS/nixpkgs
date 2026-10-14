{
  lib,
  aiohttp,
  aiointercept,
  buildPythonPackage,
  deepdiff,
  fetchFromGitHub,
  hatchling,
  mcp,
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
  version = "2025.7.0";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    tag = finalAttrs.version;
    hash = "sha256-2TuN3pAIJDh6H++iWGcoJOjT0lHVlia74dOGiRIva40=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    deepdiff
    mcp
    pycognito
    pyjwt
  ]
  ++ mcp.optional-dependencies.cli;

  nativeCheckInputs = [
    aiointercept
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
