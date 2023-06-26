{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, backoff
, googleapis-common-protos
, grpcio
, hatchling
, opentelemetry-test-utils
, opentelemetry-exporter-otlp-proto-common
, pytest-grpc
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp-proto-grpc";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-feAmPL/G3ABIY5tBODlMJIBzxqg6Bl7imJB2EYtEp2o=";
    sparseCheckout = [ "/exporter/${pname}" ];
  } + "/exporter/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    backoff
    googleapis-common-protos
    grpcio
    opentelemetry-exporter-otlp-proto-common
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/performance/benchmarks/"
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.grpc" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-grpc";
    description = "OpenTelemetry Collector Protobuf over gRPC Exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
