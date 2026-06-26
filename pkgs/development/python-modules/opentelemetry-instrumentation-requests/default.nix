{
  buildPythonPackage,
  fetchpatch,
  requests,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  httpretty,
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-requests";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-requests";

  patches = [
    # remove hardcoded requests version from fixtures
    (fetchpatch {
      url = "https://github.com/open-telemetry/opentelemetry-python-contrib/commit/69a94e0c3b25edfdc4abeb18a4d26f5b7532e7ba.patch";
      stripLen = 2;
      includes = [ "tests/test_requests_integration.py" ];
      hash = "sha256-JGWJVHR6lAg8bG1fpfJ4BJbqipnVFRLV7i/bKwOmtPk=";
    })
  ];

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    requests
  ];

  nativeCheckInputs = [
    httpretty
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.requests" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-requests";
    description = "Requests instrumentation for OpenTelemetry";
  };
}
