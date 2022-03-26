{ lib
, asynctest
, aiohttp
, blinker
, buildPythonPackage
, certifi
, ecs-logging
, fetchFromGitHub
, httpx
, jinja2
, jsonschema
, Logbook
, mock
, pytest-asyncio
, pytest-bdd
, pytest-localserver
, pytest-mock
, pytestCheckHook
, pythonOlder
, sanic
, sanic-testing
, starlette
, structlog
, tornado
, urllib3
, webob
}:

buildPythonPackage rec {
  pname = "elastic-apm";
  version = "6.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    rev = "v${version}";
    sha256 = "sha256-5G+ALFDEClItXvSQFGari0QdhW+RGV8FukxUoxqphFg=";
  };

  propagatedBuildInputs = [
    aiohttp
    blinker
    certifi
    sanic
    starlette
    tornado
    urllib3
  ];

  checkInputs = [
    asynctest
    ecs-logging
    jinja2
    jsonschema
    Logbook
    mock
    httpx
    pytest-asyncio
    pytest-bdd
    pytest-mock
    pytest-localserver
    sanic-testing
    pytestCheckHook
    structlog
    webob
  ];

  disabledTests = [
    "elasticapm_client"
  ];

  disabledTestPaths = [
    # Exclude tornado tests
    "tests/contrib/asyncio/tornado/tornado_tests.py"
  ];

  pythonImportsCheck = [
    "elasticapm"
  ];

  meta = with lib; {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
