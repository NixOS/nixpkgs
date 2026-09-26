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

buildPythonPackage (finalAttrs: {
  pname = "peblar";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-peblar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LgeMj0/X+32P9FNBMrlhxql8Mjgi9Gmroquet8rkmis=";
  };

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
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "peblar" ];

  meta = {
    description = "Python client for Peblar EV chargers";
    homepage = "https://github.com/frenck/python-peblar";
    changelog = "https://github.com/frenck/python-peblar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "peblar";
    maintainers = with lib.maintainers; [ fab ];
  };
})
