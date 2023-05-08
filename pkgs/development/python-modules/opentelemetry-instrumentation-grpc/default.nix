{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-sdk
, opentelemetry-semantic-conventions
, wrapt
, grpcio
, opentelemetry-instrumentation-grpc
, opentelemetry-test-utils
, protobuf
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-grpc";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-grpc";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    grpcio
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    wrapt
  ];

  passthru.optional-dependencies = {
    instruments = [
      grpcio
    ];
    test = [
      opentelemetry-instrumentation-grpc
      opentelemetry-sdk
      opentelemetry-test-utils
      protobuf
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.grpc" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
