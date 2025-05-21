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
  pythonOlder,
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
  version = "6.23.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    tag = "v${version}";
    hash = "sha256-S1Ebo9AWN+Mf3OFwxNTiR/AZtje3gNiYkZnVqGb7D4c=";
  };

  patches = [
    (fetchpatch {
      name = "fix-tests-with-latest-starlette-and-sanic.patch";
      url = "https://github.com/elastic/apm-agent-python/commit/80d167f54b6bf1db8b6e7ee52e2ac6803bc64f54.patch";
      hash = "sha256-VtA7+SyEZiL3aqpikyYJQ4tmdmsUpIdkSx6RtC1AzqY=";
    })
  ];

  pythonRelaxDeps = [ "wrapt" ];

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

  disabledTests = [ "elasticapm_client" ];

  disabledTestPaths =
    [
      # Exclude tornado tests
      "tests/contrib/asyncio/tornado/tornado_tests.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Flaky tests on Darwin
      "tests/utils/threading_tests.py"
    ];

  pythonImportsCheck = [ "elasticapm" ];

  meta = with lib; {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    changelog = "https://github.com/elastic/apm-agent-python/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "elasticapm-run";
  };
}
