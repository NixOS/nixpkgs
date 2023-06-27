{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, backoff
, hatchling
, opentelemetry-exporter-otlp-proto-grpc
, opentelemetry-exporter-otlp-proto-http
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-otlp";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ph9ahT6M8UBvuUJjk6nug68Ou/D7XuuXkfnKHEdD8x8=";
    sparseCheckout = [ "/exporter/${pname}" ];
  } + "/exporter/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-exporter-otlp-proto-http
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.otlp" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-otlp";
    description = "OpenTelemetry Collector Exporters";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
