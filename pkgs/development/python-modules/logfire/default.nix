{
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  lib,

  # build-system
  hatchling,

  # dependencies
  executing,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation,
  opentelemetry-sdk,
  protobuf,
  rich,
  tomli,
  typing-extensions,

  # optional dependencies
  opentelemetry-instrumentation-aiohttp-client,
  opentelemetry-instrumentation-asgi,
  opentelemetry-instrumentation-celery,
  opentelemetry-instrumentation-django,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-instrumentation-flask,
  opentelemetry-instrumentation-httpx,
  opentelemetry-instrumentation-psycopg2,
  opentelemetry-instrumentation-redis,
  opentelemetry-instrumentation-requests,
  opentelemetry-instrumentation-sqlalchemy,
  opentelemetry-instrumentation-wsgi,
  packaging,

  # test dependencies
  anthropic,
  anyio,
  asyncpg,
  cloudpickle,
  dirty-equals,
  google-genai,
  inline-snapshot,
  logfire-api,
  loguru,
  mysql-connector,
  openai-agents,
  pandas,
  psycopg,
  pymongo,
  pymysql,
  pytest-django,
  pytest-vcr,
  pytest-xdist,
  pytestCheckHook,
  redis,
  requests-mock,
  sqlmodel,
  structlog,
  testcontainers,
}:

buildPythonPackage (finalAttrs: {
  pname = "logfire";
  version = "4.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "logfire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dAkT3xh0RsGTnW7Mqml2wV16VHJGUUkjjxiFLg9bUKc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    executing
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation
    opentelemetry-sdk
    protobuf
    rich
    tomli
    typing-extensions
  ];

  # Some optional dependencies are commented out because the deps they require
  # are not in nixpkgs as of writing
  optional-dependencies = {
    aiohttp = [ opentelemetry-instrumentation-aiohttp-client ];
    aiohttp-client = [ opentelemetry-instrumentation-aiohttp-client ];
    # aiohttp-server = [ opentelemetry-instrumentation-aiohttp-server ];
    asgi = [ opentelemetry-instrumentation-asgi ];
    # asyncpg = [ opentelemetry-instrumentation-asyncpg ];
    # aws-lambda = [ opentelemetry-instrumentation-aws-lambda ];
    celery = [ opentelemetry-instrumentation-celery ];
    django = [
      opentelemetry-instrumentation-asgi
      opentelemetry-instrumentation-django
    ];
    # dspy = [ opentelemetry-instrumentation-dspy ];
    fastapi = [ opentelemetry-instrumentation-fastapi ];
    flask = [ opentelemetry-instrumentation-flask ];
    # google-genai = [ opentelemetry-instrumentation-google-genai ];
    httpx = [ opentelemetry-instrumentation-httpx ];
    # litellm = [ opentelemetry-instrumentation-litellm ];
    # mysql = [ opentelemetry-instrumentation-mysql ];
    psycopg = [
      # opentelemetry-instrumentation-psycopg
      packaging
    ];
    psycopg2 = [
      opentelemetry-instrumentation-psycopg2
      packaging
    ];
    # pymongo = [ opentelemetry-instrumentation-pymongo ];
    redis = [ opentelemetry-instrumentation-redis ];
    requests = [ opentelemetry-instrumentation-requests ];
    sqlalchemy = [ opentelemetry-instrumentation-sqlalchemy ];
    # sqlite3 = [ opentelemetry-instrumentation-sqlite3 ];
    # starlette = [ opentelemetry-instrumentation-starlette ];
    # system-metrics = [ opentelemetry-instrumentation-system-metrics ];
    wsgi = [ opentelemetry-instrumentation-wsgi ];
  };

  pythonImportsCheck = [ "logfire" ];

  # Too many outdated snapshots that fail with inline-snapshot
  doCheck = false;

  nativeCheckInputs = [
    anthropic
    anyio
    asyncpg
    cloudpickle
    dirty-equals
    google-genai
    inline-snapshot
    logfire-api
    loguru
    mysql-connector
    openai-agents
    pandas
    psycopg
    pymongo
    pymysql
    pytest-django
    pytest-vcr
    pytest-xdist
    pytestCheckHook
    redis
    requests-mock
    sqlmodel
    structlog
    testcontainers
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # Tests that require the commented optional dependencies above
    "tests/otel_integrations/test_aiohttp_server.py"
    "tests/otel_integrations/test_asyncpg.py"
    "tests/otel_integrations/test_aws_lambda.py"
    "tests/otel_integrations/test_google_genai.py"
    "tests/otel_integrations/test_mysql.py"
    "tests/otel_integrations/test_psycopg.py"
    "tests/otel_integrations/test_pymongo.py"
    "tests/otel_integrations/test_sqlalchemy.py"
    "tests/otel_integrations/test_sqlite3.py"
    "tests/otel_integrations/test_starlette.py"
    "tests/otel_integrations/test_system_metrics.py"

    # No module named 'litellm'
    "tests/otel_integrations/test_litellm.py::test_litellm_instrumentation"

    # No module named 'pydantic_ai'
    "tests/otel_integrations/test_pydantic_ai.py"

    # DeprecationWarning: The @wait_container_is_ready decorator is deprecated and will be removed in a future version. Use structured wait strategies instead: container.waiting_for(HttpWaitStrategy(8080).for_status_code(200)) or container.waiting_for(LogMessageWaitStrategy('ready'))
    "tests/otel_integrations/test_celery.py"
    "tests/otel_integrations/test_redis.py"

    # Requires network
    "tests/test_query_client.py"
    "tests/otel_integrations/test_openai.py"
    "tests/otel_integrations/test_openai_agents.py"
  ];

  meta = {
    changelog = "https://logfire.pydantic.dev/docs/release-notes";
    description = "Uncomplicated Observability for Python and beyond";
    downloadPage = "https://github.com/pydantic/logfire/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://logfire.pydantic.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
