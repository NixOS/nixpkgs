{
  buildPythonPackage,
  cloudpickle,
  docker,
  fakeredis,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  lib,
  opentelemetry-api,
  opentelemetry-exporter-prometheus,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-redis,
  prometheus-client,
  pytestCheckHook,
  py-key-value-aio,
  pytest-asyncio,
  pytest-cov,
  pytest-timeout,
  pytest-xdist,
  python-json-logger,
  redis,
  rich,
  typer,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pydocket";
  version = "0.16.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisguidry";
    repo = "docket";
    tag = version;
    hash = "sha256-DNq+PUbh6SfazxkM7tbjEOXbh1VSJPM3jEkgn64XQ5g=";
  };

  build-system = [
    hatchling
    hatch-vcs
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

  pythonRelaxDeps = [
    "fakeredis"
    "opentelemetry-exporter-prometheus"
    "opentelemetry-instrumentation"
  ];

  nativeCheckInputs = [
    docker
    opentelemetry-instrumentation-redis
    pytest-asyncio
    pytest-cov
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    export REDIS_VERSION=memory
  '';

  disabledTests = [
    # Require network socket binding
    "test_healthcheck_server_returns_ok"
    "test_exports_metrics_as_prometheus_metrics"
    # These tests fail when using fakeredis instead of real Redis
    "test_internal_redis_polling_spans_suppressed_by_default"
    "test_docket_strike_xread_spans_suppressed_by_default"
  ];

  pythonImportsCheck = [ "docket" ];

  meta = {
    description = "A distributed background task system for Python";
    homepage = "https://chrisguidry.github.io/docket/";
    changelog = "https://github.com/chrisguidry/docket/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
