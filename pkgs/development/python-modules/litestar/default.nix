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
  multipart,
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
  httpx-sse,
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
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "litestar";
    tag = "v${version}";
    hash = "sha256-rF/TQT1TgvM24BxjKY9nmCMNTsEijmesx3IHFjiQFg4=";
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
    httpx-sse
    jinja2
    litestar-htmx
    mako
    msgspec
    multidict
    multipart
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
  versionCheckProgramArg = [ "version" ];

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    # Follow github CI
    "docs/examples/testing"
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
