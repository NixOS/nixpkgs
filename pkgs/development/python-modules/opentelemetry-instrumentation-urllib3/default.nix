{
  buildPythonPackage,
  opentelemetry-instrumentation,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-api,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  wrapt,

  # optional-dependencies
  urllib3,

  # tests
  httpretty,
  opentelemetry-test-utils,
  pytestCheckHook,
  respx,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-urllib3";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-urllib3";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
    opentelemetry-util-http
  ];

  optional-dependencies = {
    instruments = [
      urllib3
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.urllib3" ];

  nativeCheckInputs = [
    httpretty
    opentelemetry-test-utils
    pytestCheckHook
    respx
    urllib3
  ];

  __darwinAllowLocalNetworking = true;

  meta = opentelemetry-instrumentation.meta // {
    description = "OpenTelemetry urllib3 instrumentation";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-urllib3";
  };
}
