{ lib
, buildPythonPackage
, pythonOlder
, hatchling
, opentelemetry-instrumentation
, opentelemetry-sdk
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, pytestCheckHook
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-util-http";
  disabled = pythonOlder "3.7";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/util/opentelemetry-util-http";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-instrumentation
    opentelemetry-sdk
    opentelemetry-semantic-conventions
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  # https://github.com/open-telemetry/opentelemetry-python-contrib/issues/1940
  disabledTests = [
    "test_nonstandard_method"
    "test_nonstandard_method_allowed"
  ];

  pythonImportsCheck = [ "opentelemetry.util.http" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/util/opentelemetry-util-http";
    description = "Web util for OpenTelemetry";
  };
}
