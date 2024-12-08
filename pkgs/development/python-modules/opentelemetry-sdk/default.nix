{
  buildPythonPackage,
  pythonOlder,
  flaky,
  hatchling,
  opentelemetry-api,
  opentelemetry-semantic-conventions,
  opentelemetry-test-utils,
  typing-extensions,
  pytestCheckHook,
}:

let
  self = buildPythonPackage {
    inherit (opentelemetry-api) version src;
    pname = "opentelemetry-sdk";
    pyproject = true;

    disabled = pythonOlder "3.8";

    sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-sdk";

    build-system = [ hatchling ];

    dependencies = [
      opentelemetry-api
      opentelemetry-semantic-conventions
      typing-extensions
    ];

    nativeCheckInputs = [
      flaky
      opentelemetry-test-utils
      pytestCheckHook
    ];

    disabledTestPaths = [ "tests/performance/benchmarks/" ];

    pythonImportsCheck = [ "opentelemetry.sdk" ];

    doCheck = false;

    # Enable tests via passthru to avoid cyclic dependency with opentelemetry-test-utils.
    passthru.tests.${self.pname} = self.overridePythonAttrs { doCheck = true; };

    meta = opentelemetry-api.meta // {
      homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-sdk";
      description = "OpenTelemetry Python SDK";
    };
  };
in
self
