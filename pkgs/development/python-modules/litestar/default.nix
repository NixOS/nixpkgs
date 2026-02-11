{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  annotated-types,
  anyio,
  asyncpg,
  attrs,
  brotli,
  click,
  cryptography,
  fsspec,
  httpx,
  jinja2,
  jsbeautifier,
  litestar-htmx,
  mako,
  minijinja,
  fast-query-parsers,
  msgspec,
  multidict,
  multipart,
  picologging,
  polyfactory,
  piccolo,
  prometheus-client,
  psutil,
  opentelemetry-instrumentation-asgi,
  pydantic-extra-types,
  pydantic,
  email-validator,
  pyjwt,
  pyyaml,
  redis,
  rich-click,
  rich,
  structlog,
  time-machine,
  typing-extensions,
  uvicorn,
  # valkey,

  # tests
  addBinToPathHook,
  httpx-sse,
  pytest-asyncio,
  pytest-lazy-fixtures,
  pytest-mock,
  pytest-rerunfailures,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  trio,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "litestar";
  version = "2.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "litestar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a72CUCwxeBluJI7kYShg0RuPEA58j52AkgHnokI4E28=";
  };

  build-system = [ hatchling ];

  dependencies = [
    anyio
    asyncpg
    click
    fast-query-parsers
    fsspec
    httpx
    litestar-htmx
    msgspec
    multidict
    multipart
    polyfactory
    psutil
    pyyaml
    rich
    rich-click
    typing-extensions
  ];

  optional-dependencies = {
    annotated-types = [ annotated-types ];
    attrs = [ attrs ];
    brotli = [ brotli ];
    cli = [
      jsbeautifier
      uvicorn
    ];
    cryptography = [ cryptography ];
    htmx = [ litestar-htmx ];
    jinja = [ jinja2 ];
    jwt = [
      cryptography
      pyjwt
    ];
    mako = [ mako ];
    minijinja = [ minijinja ];
    opentelemetry = [ opentelemetry-instrumentation-asgi ];
    piccolo = [ piccolo ];
    picologging = [ picologging ];
    polyfactory = [ polyfactory ];
    prometheus = [ prometheus-client ];
    pydantic = [
      pydantic
      email-validator
      pydantic-extra-types
    ];
    redis = [ redis ] ++ redis.optional-dependencies.hiredis;
    # sqlalchemy = [ advanced-alchemy ];
    structlog = [ structlog ];
    # valkey = [ valkey ] ++ valkey.optional-dependencies.libvalkey;
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    addBinToPathHook
    httpx-sse
    pytest-asyncio
    pytest-lazy-fixtures
    pytest-mock
    pytest-rerunfailures
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    time-machine
    trio
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  __darwinAllowLocalNetworking = true;

  enabledTestPaths = [
    # Follow GitHub CI
    "docs/examples/"
  ];

  pytestFlags = lib.optionals (pythonAtLeast "3.14") [
    # UserWarning: Core Pydantic V1 functionality isn't compatible with Python 3.14 or greater.
    "-Wignore::UserWarning"
  ];

  disabledTests = [
    # StartupError
    "test_subprocess_async_client"
  ];

  meta = {
    description = "Production-ready, Light, Flexible and Extensible ASGI API framework";
    homepage = "https://litestar.dev/";
    changelog = "https://github.com/litestar-org/litestar/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "litestar";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
  };
})
