{
  lib,
  buildPythonPackage,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  botocore,
  moto,
  opentelemetry-test-utils,
  opentelemetry-propagator-aws-xray,
  pytestCheckHook,
  aws-xray-sdk,
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-botocore";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-botocore";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-propagator-aws-xray
    opentelemetry-semantic-conventions
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  checkInputs = [
    aws-xray-sdk
    moto
  ];

  optional-dependencies = {
    instruments = [ botocore ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.botocore" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-botocore";
    description = "Botocore instrumentation for OpenTelemetry";
  };
}
