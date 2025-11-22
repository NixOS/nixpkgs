{
  lib,
  stdenv,
  aiohttp,
  blinker,
  buildPythonPackage,
  certifi,
  ecs-logging,
  fetchFromGitHub,
  fetchpatch,
  httpx,
  jinja2,
  jsonschema,
  logbook,
  mock,
  pytest-asyncio,
  pytest-bdd,
  pytest-localserver,
  pytest-mock,
  pytest-random-order,
  pytestCheckHook,
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

buildPythonPackage rec {
  pname = "elastic-apm";
  version = "6.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    tag = "v${version}";
    hash = "sha256-8Q2fzaIG9dghjt4T00nqffGEfPDr4DEcdeHPJqhU8fs=";
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

  disabledTests = [
    "elasticapm_client"
    "test_get_name_from_func_partialmethod_unbound"
  ];

  disabledTestPaths = [
    # Exclude tornado tests
    "tests/contrib/asyncio/tornado/tornado_tests.py"
    # Exclude client tests
    "tests/instrumentation/asyncio_tests/aiohttp_client_tests.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky tests on Darwin
    "tests/utils/threading_tests.py"
  ];

  pythonImportsCheck = [ "elasticapm" ];

  meta = with lib; {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    changelog = "https://github.com/elastic/apm-agent-python/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "elasticapm-run";
  };
}
