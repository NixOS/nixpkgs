{ lib
, buildPythonPackage
, pythonOlder
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, wrapt
, pytestCheckHook
, aiohttp
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-aiohttp-client";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-aiohttp-client";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    wrapt
    aiohttp
  ];

  # missing https://github.com/ezequielramos/http-server-mock
  # which looks unmaintained
  doCheck = false;

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.aiohttp_client" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-aiohttp-client";
    description = "OpenTelemetry Instrumentation for aiohttp-client";
  };
}
