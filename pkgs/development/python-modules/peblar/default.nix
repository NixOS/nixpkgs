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
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  syrupy,
  tenacity,
  typer,
  yarl,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "peblar";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-peblar";
    tag = "v${version}";
    hash = "sha256-co3440R9OVEdcLPNsBu1jz6WzZTz746IEFcyTlzNkc0=";
  };

  patches = [
    ./typer-0.26.patch
  ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    tenacity
    yarl
  ];

  optional-dependencies = {
    cli = [
      rich
      typer
      zeroconf
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "peblar" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python client for Peblar EV chargers";
    homepage = "https://github.com/frenck/python-peblar";
    changelog = "https://github.com/frenck/python-peblar/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "peblar";
    maintainers = with lib.maintainers; [ fab ];
  };
}
