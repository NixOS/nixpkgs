{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-proto
, opentelemetry-sdk
, opentelemetry-test-utils
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp-proto-common";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-HNlkbDyYnr0/lDeY1xt0pRxqk+977ljgPdfJzAxL3AQ=";
    sparseCheckout = [ "/exporter/${pname}" ];
  } + "/exporter/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-sdk
    opentelemetry-proto
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.common" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp-proto-common";
    description = "OpenTelemetry Protobuf encoding";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
