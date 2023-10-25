{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, backoff
, googleapis-common-protos
, hatchling
, opentelemetry-exporter-otlp-proto-common
, opentelemetry-test-utils
, requests
, responses
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp-proto-http";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-r4jvIhRM9E4CuZyS/XvvYO+F9cPxip8ab57CUfip47Q=";
    sparseCheckout = [ "/exporter/${pname}" ];
  } + "/exporter/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    backoff
    googleapis-common-protos
    opentelemetry-exporter-otlp-proto-common
    requests
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.http" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-http";
    description = "OpenTelemetry Collector Protobuf over HTTP Exporter";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
