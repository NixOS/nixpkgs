{ lib
, stdenv
, aiohttp
, blinker
, buildPythonPackage
, certifi
, ecs-logging
, fetchFromGitHub
, httpx
, jinja2
, jsonschema
, logbook
, mock
, pytest-asyncio
, pytest-bdd
, pytest-localserver
, pytest-mock
, pytest-random-order
, pytestCheckHook
, pythonOlder
, sanic
, sanic-testing
, starlette
, structlog
, tornado
, urllib3
, webob
, wrapt
}:

buildPythonPackage rec {
  pname = "elastic-apm";
  version = "6.16.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-m/PjL8pltUpv/ewE/gksISsOhEVsyeWoq6yfd5c1j6s=";
  };

  propagatedBuildInputs = [
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
  ];

  disabledTestPaths = [
    # Exclude tornado tests
    "tests/contrib/asyncio/tornado/tornado_tests.py"
  ] ++ lib.optionals stdenv.isDarwin [
    # Flaky tests on Darwin
    "tests/utils/threading_tests.py"
  ];

  pythonImportsCheck = [
    "elasticapm"
  ];

  meta = with lib; {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    changelog = "https://github.com/elastic/apm-agent-python/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "elasticapm-run";
  };
}
