{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  cloudpickle,
  fakeredis,
  opentelemetry-api,
  opentelemetry-exporter-prometheus,
  opentelemetry-instrumentation,
  prometheus-client,
  py-key-value-aio,
  python-json-logger,
  redis,
  rich,
  typer,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydocket";
  version = "0.16.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisguidry";
    repo = "docket";
    tag = finalAttrs.version;
    hash = "sha256-DNq+PUbh6SfazxkM7tbjEOXbh1VSJPM3jEkgn64XQ5g=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonRelaxDeps = [
    "fakeredis"
    "opentelemetry-exporter-prometheus"
    "opentelemetry-instrumentation"
  ];
  dependencies = [
    cloudpickle
    fakeredis
    opentelemetry-api
    opentelemetry-exporter-prometheus
    opentelemetry-instrumentation
    prometheus-client
    py-key-value-aio
    python-json-logger
    redis
    rich
    typer
    typing-extensions
  ]
  ++ fakeredis.optional-dependencies.lua
  ++ py-key-value-aio.optional-dependencies.memory
  ++ py-key-value-aio.optional-dependencies.redis;

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
