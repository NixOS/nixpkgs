{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # dependencies
  opentelemetry-api,
  opentelemetry-sdk,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "opentelemetry-resourcedetector-gcp";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = "opentelemetry-operations-python";
    tag = "v${version}";
    hash = "sha256-aBDY6Ux8yeiD2/NqOHnbZSmRrCORlEqHQcPLC7OEfvU=";
  };

  sourceRoot = "${src.name}/opentelemetry-resourcedetector-gcp";

  dependencies = [
    opentelemetry-api
    opentelemetry-sdk
    requests
    typing-extensions
  ];

  meta = {
    description = "OpenTelemetry Python library for detecting GCP resources like GCE, GKE, etc.";
    homepage = "https://github.com/GoogleCloudPlatform/opentelemetry-operations-python/tree/main/opentelemetry-resourcedetector-gcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ RajwolChapagain ];
  };
}
