{
  lib,
  aiohttp,
  aiointercept,
  awesomeversion,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  syrupy,
  typer,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "adguardhome";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-adguardhome";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UpRr1HTh7BMNWL4ml6pWe+AsIy4MEgTpa4HgdzH36oQ=";
  };

  patches = [
    # https://github.com/frenck/python-adguardhome/pull/1870
    ./typer-0.26.patch
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    yarl
  ];

  optional-dependencies = {
    cli = [
      rich
      typer
    ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aiointercept
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  disabledTests = [
    # fixture formatting differs
    "test_config"
    "test_get"
    "test_stats"
    "test_status"
  ];

  pythonImportsCheck = [ "adguardhome" ];

  meta = {
    description = "Python client for the AdGuard Home API";
    homepage = "https://github.com/frenck/python-adguardhome";
    changelog = "https://github.com/frenck/python-adguardhome/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
})
