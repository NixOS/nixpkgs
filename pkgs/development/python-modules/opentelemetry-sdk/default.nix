{ lib
, buildPythonPackage
, pythonOlder
, flaky
, hatchling
, opentelemetry-api
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, setuptools
, typing-extensions
, pytestCheckHook
}:

let
  self = buildPythonPackage {
    inherit (opentelemetry-api) version src;
    pname = "opentelemetry-sdk";
    disabled = pythonOlder "3.7";

    sourceRoot = "${opentelemetry-api.src.name}/opentelemetry-sdk";

    format = "pyproject";

    nativeBuildInputs = [
      hatchling
    ];

    propagatedBuildInputs = [
      opentelemetry-api
      opentelemetry-semantic-conventions
      setuptools
      typing-extensions
    ];

    nativeCheckInputs = [
      flaky
      opentelemetry-test-utils
      pytestCheckHook
    ];

    disabledTestPaths = [
      "tests/performance/benchmarks/"
    ];

    pythonImportsCheck = [ "opentelemetry.sdk" ];

    doCheck = false;

    # Enable tests via passthru to avoid cyclic dependency with opentelemetry-test-utils.
    passthru.tests.${self.pname} = self.overridePythonAttrs { doCheck = true; };

    meta = opentelemetry-api.meta // {
      homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-sdk";
      description = "OpenTelemetry Python SDK";
    };
  };
in self
