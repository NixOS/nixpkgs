{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  certifi,
  executing,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
  protobuf,
  requests,
  rich,
  tomli,
  typing-extensions,

  # optional dependencies
  httpx,
  litestar,
  opentelemetry-instrumentation-aiohttp-client,
  opentelemetry-instrumentation-asgi,
  opentelemetry-instrumentation-celery,
  opentelemetry-instrumentation-django,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-instrumentation-flask,
  opentelemetry-instrumentation-httpx,
  opentelemetry-instrumentation-psycopg,
  opentelemetry-instrumentation-psycopg2,
  opentelemetry-instrumentation-redis,
  opentelemetry-instrumentation-requests,
  opentelemetry-instrumentation-sqlalchemy,
  opentelemetry-instrumentation-sqlite3,
  opentelemetry-instrumentation-system-metrics,
  opentelemetry-instrumentation-wsgi,
  packaging,
  pydantic,
  starlette,
  uvicorn,

  # tests
  anyio,
  dirty-equals,
  inline-snapshot,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "logfire-sdk";
  version = "5.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "logfire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CtYB3Xn89Pjt5G8sTtsybis8KSA/EKj1YyTFXjJniZI=";
  };

  sourceRoot = "${finalAttrs.src.name}/logfire-sdk";

  build-system = [ hatchling ];

  dependencies = [
    certifi
    executing
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    protobuf
    requests
    rich
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  # Optional dependency groups whose dependencies are not in nixpkgs as of writing
  # are omitted: aiohttp-server, agent-sandboxes, asyncpg, aws-lambda,
  # google-genai, litellm, dspy, mysql, pymongo, starlette, urllib, datasets,
  # variables and fleet.
  optional-dependencies = {
    gateway = [
      httpx
      starlette
      uvicorn
    ];
    litestar = [
      litestar
      pydantic
      opentelemetry-instrumentation-asgi
    ];
    asgi = [ opentelemetry-instrumentation-asgi ];
    wsgi = [ opentelemetry-instrumentation-wsgi ];
    aiohttp = [ opentelemetry-instrumentation-aiohttp-client ];
    aiohttp-client = [ opentelemetry-instrumentation-aiohttp-client ];
    celery = [ opentelemetry-instrumentation-celery ];
    django = [
      opentelemetry-instrumentation-asgi
      opentelemetry-instrumentation-django
    ];
    fastapi = [ opentelemetry-instrumentation-fastapi ];
    flask = [ opentelemetry-instrumentation-flask ];
    httpx = [ opentelemetry-instrumentation-httpx ];
    sqlalchemy = [ opentelemetry-instrumentation-sqlalchemy ];
    psycopg = [
      opentelemetry-instrumentation-psycopg
      packaging
    ];
    psycopg2 = [
      opentelemetry-instrumentation-psycopg2
      packaging
    ];
    redis = [ opentelemetry-instrumentation-redis ];
    requests = [ opentelemetry-instrumentation-requests ];
    sqlite3 = [ opentelemetry-instrumentation-sqlite3 ];
    system-metrics = [ opentelemetry-instrumentation-system-metrics ];
  };

  pythonImportsCheck = [ "logfire" ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    inline-snapshot
    pydantic
    pytestCheckHook
  ];

  # The full workspace suite requires many optional integrations and services.
  # Use an isolated pytest configuration to avoid its optional warning filters.
  pytestFlags = [
    "-c"
    "/dev/null"
    "-p"
    "no:cacheprovider"
    "../tests/test_db_statement_summary.py"
    "../tests/test_secret_scrubbing.py"
    "../tests/test_baggage.py"
  ];

  meta = {
    changelog = "https://logfire.pydantic.dev/docs/release-notes";
    description = "The best Python observability tool! 🪵🔥";
    downloadPage = "https://github.com/pydantic/logfire/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://logfire.pydantic.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
