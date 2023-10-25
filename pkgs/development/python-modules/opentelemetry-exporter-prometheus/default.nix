{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-sdk
, opentelemetry-test-utils
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-prometheus";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-vWVLUt3Ett04kqUyoTOBNvRj51/M35X83saBBxeOTZI=";
    sparseCheckout = [ "/exporter/${pname}" ];
  } + "/exporter/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-sdk
    prometheus-client
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.exporter.prometheus" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-prometheus";
    description = "Prometheus Metric Exporter for OpenTelemetry";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
