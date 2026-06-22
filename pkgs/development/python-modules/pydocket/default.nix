{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  burner-redis,
  cloudpickle,
  cronsim,
  opentelemetry-api,
  opentelemetry-sdk,
  prometheus-client,
  py-key-value-aio,
  python-json-logger,
  redis,
  rich,
  typer,
  typing-extensions,
  uncalled-for,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydocket";
  version = "0.21.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chrisguidry";
    repo = "docket";
    tag = finalAttrs.version;
    hash = "sha256-2YBX/PaR0ebQBkx/Z72TSxlTzY8MWBJu+0mEanLfvnU=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    burner-redis
    cloudpickle
    cronsim
    opentelemetry-api
    prometheus-client
    py-key-value-aio
    python-json-logger
    redis
    rich
    typer
    typing-extensions
    uncalled-for
  ]
  ++ py-key-value-aio.optional-dependencies.memory
  ++ py-key-value-aio.optional-dependencies.redis;

  optional-dependencies = {
    metrics = [
      opentelemetry-sdk
    ];
  };

  pythonImportsCheck = [ "docket" ];

  # All tests require internet access
  doCheck = false;

  meta = {
    description = "Distributed background task system for Python";
    homepage = "https://github.com/chrisguidry/docket";
    changelog = "https://github.com/chrisguidry/docket/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
