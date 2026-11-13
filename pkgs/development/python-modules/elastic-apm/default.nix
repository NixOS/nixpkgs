{
  lib,
  stdenv,
  aiohttp,
  blinker,
  buildPythonPackage,
  certifi,
  ecs-logging,
  fetchFromGitHub,
  httpx,
  jinja2,
  jsonschema,
  logbook,
  mock,
  psutil,
  pytest-asyncio,
  pytest-bdd,
  pytest-localserver,
  pytest-mock,
  pytest-random-order,
  pytestCheckHook,
  versionCheckHook,
  sanic,
  sanic-testing,
  setuptools,
  starlette,
  structlog,
  tornado,
  urllib3,
  webob,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "elastic-apm";
  version = "6.26.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KfZbRwIQ+DW3gfCkJeo7oSUs4LRsUnvtzbyB7BgGA7E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    blinker
    certifi
    sanic
    starlette
    tornado
    urllib3
    wrapt
  ];

  nativeCheckInputs = [
    ecs-logging
    httpx
    jinja2
    jsonschema
    logbook
    mock
    psutil
    pytest-asyncio
    pytest-bdd
    pytest-localserver
    pytest-mock
    pytest-random-order
    pytestCheckHook
    sanic-testing
    structlog
    webob
  ];

  disabledTestPaths = [
    # Exclude tornado tests
    "tests/contrib/asyncio/tornado/tornado_tests.py"
    # Exclude starlette test
    "tests/contrib/asyncio/starlette_tests.py"
    # Exclude client tests
    "tests/instrumentation/asyncio_tests/aiohttp_client_tests.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky tests on Darwin
    "tests/utils/threading_tests.py"
  ];

  pythonImportsCheck = [ "elasticapm" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    changelog = "https://github.com/elastic/apm-agent-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "elasticapm-run";
  };
})
