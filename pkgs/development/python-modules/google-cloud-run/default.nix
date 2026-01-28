{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  grpc-google-iam-v1,
  grpcio,
  proto-plus,
  protobuf,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-run";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_run";
    inherit (finalAttrs) version;
    hash = "sha256-FY8mRkP5gr+k9PGPnijFbqAOqVwki8inRuFZtTivq1c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpc-google-iam-v1
    grpcio
    proto-plus
    protobuf
  ];

  # Tests are only available in the google-cloud-python monorepo
  doCheck = false;

  pythonImportsCheck = [ "google.cloud.run" ];

  meta = {
    description = "Google Cloud Run API client library";
    homepage = "https://pypi.org/project/google-cloud-run/";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-run-v${finalAttrs.version}/packages/google-cloud-run/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
