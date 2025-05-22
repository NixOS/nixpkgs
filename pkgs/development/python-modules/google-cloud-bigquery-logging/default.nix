{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  grpc-google-iam-v1,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery-logging";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-bigquery-logging-v${version}";
    hash = "sha256-5PzidE1CWN+pt7+gcAtbuXyL/pq6cnn0MCRkBfmeUSw=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-bigquery-logging";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery_logging"
    "google.cloud.bigquery_logging_v1"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "google-cloud-bigquery-logging-v([0-9.]+)"
    ];
  };

  meta = {
    description = "Bigquery logging client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-bigquery-logging";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-bigquery-logging-v${version}/packages/google-cloud-bigquery-logging/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
  };
}
