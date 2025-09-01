{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  asyncpg,
  click,
  cryptography,
  fsspec,
  httpx,
  jinja2,
  litestar-htmx,
  mako,
  msgspec,
  multidict,
  picologging,
  polyfactory,
  psutil,
  psycopg,
  pyyaml,
  redis,
  rich,
  rich-click,
  time-machine,
  trio,
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-lazy-fixtures,
  pytest-xdist,
  pytest-mock,
  pytest-asyncio,
  pytest-timeout,
  pytest-rerunfailures,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "litestar";
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "litestar";
    tag = "v${version}";
    hash = "sha256-67O/NxPBBLa1QfH1o9laOAQEin8jRA8SkcV7QEzCjI0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    anyio
    asyncpg
    click
    cryptography
    fsspec
    httpx
    jinja2
    litestar-htmx
    mako
    msgspec
    multidict
    picologging
    polyfactory
    psutil
    psycopg
    pyyaml
    redis
    rich
    rich-click
    time-machine
    trio
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-lazy-fixtures
    pytest-xdist
    pytest-mock
    pytest-asyncio
    pytest-timeout
    pytest-rerunfailures
    versionCheckHook
  ];
  versionCheckProgramArg = "version";

  __darwinAllowLocalNetworking = true;

  enabledTestPaths = [
    # Follow github CI
    "docs/examples/"
  ];

  meta = {
    homepage = "https://litestar.dev/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/litestar-org/litestar/releases/tag/${src.tag}";
    description = "Production-ready, Light, Flexible and Extensible ASGI API framework";
    license = lib.licenses.mit;
    mainProgram = "litestar";
  };
}
