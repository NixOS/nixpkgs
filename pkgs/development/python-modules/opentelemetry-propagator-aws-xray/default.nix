{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, botocore
, markupsafe
, moto
, opentelemetry-instrumentation-botocore
, opentelemetry-test-utils
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-propagator-aws-xray";
  format = "pyproject";

  sourceRoot = "source/propagator/opentelemetry-propagator-aws-xray";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    botocore
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
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

  # FIXME
  #pythonImportsCheck = [ "opentelemetry.propagator.aws-xray" ];

  meta = {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.onny ];
  };
}
