{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  aioresponses,
  awesomeversion,
  mashumaro,
  orjson,
  poetry-core,
  probatio,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  rich,
  syrupy,
  typer,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "ritualsgenie";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-ritualsgenie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WnoEcwBnPj7ww0ddp93FMha94hlB1LqTq0WQwv+/pus=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];
  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    mashumaro
    orjson
    probatio
    yarl
  ];

  optional-dependencies.cli = [
    rich
    typer
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  pythonImportsCheck = [ "ritualsgenie" ];

  meta = {
    description = "Asynchronous Python client for the Rituals Perfume Genie API";
    homepage = "https://github.com/frenck/python-ritualsgenie";
    changelog = "https://github.com/frenck/python-ritualsgenie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
