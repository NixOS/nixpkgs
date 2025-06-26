{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # dependencies
  google-cloud-trace,
  opentelemetry-api,
  opentelemetry-resourcedetector-gcp,
  opentelemetry-sdk,
}:

buildPythonPackage rec {
  pname = "opentelemetry-exporter-gcp-trace";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "opentelemetry-operations-python";
    tag = "v${version}";
    hash = "sha256-aBDY6Ux8yeiD2/NqOHnbZSmRrCORlEqHQcPLC7OEfvU=";
  };

  sourceRoot = "${src.name}/opentelemetry-exporter-gcp-trace";

  dependencies = [
    google-cloud-trace
    opentelemetry-api
    opentelemetry-resourcedetector-gcp
    opentelemetry-sdk
  ];

  pythonImportsCheck = [
    "opentelemetry.trace"
    "opentelemetry.exporter.cloud_trace"
  ];

  meta = with lib; {
    description = "OpenTelemetry Python exporter for Google Cloud Trace";
    homepage = "https://github.com/GoogleCloudPlatform/opentelemetry-operations-python/tree/main/opentelemetry-exporter-gcp-trace";
    license = licenses.asl20;
    maintainers = with maintainers; [ RajwolChapagain ];
  };
}
