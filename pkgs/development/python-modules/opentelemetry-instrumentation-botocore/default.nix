{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  botocore,
  markupsafe,
  moto,
  opentelemetry-instrumentation-botocore,
  opentelemetry-test-utils,
  opentelemetry-propagator-aws-xray,
  pytestCheckHook,
  fetchpatch,
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-botocore";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-botocore";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-propagator-aws-xray
  ];

  nativeCheckInputs = [
    botocore
    moto
    pytestCheckHook
  ];

  passthru.optional-dependencies = {
    instruments = [
      botocore
    ];
    test = [
      markupsafe
      moto
      opentelemetry-instrumentation-botocore
      opentelemetry-test-utils
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.botocore" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-botocore";
    description = "OpenTelemetry Instrumentation for Botocore";
  };
}
