{
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  grpc-google-iam-v1,
  lib,
  proto-plus,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-artifact-registry";
  version = "1.13.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_artifact_registry";
    inherit version;
    hash = "sha256-wbr6WfuA9n94DK/B0OKS8PrnP1tiCRORKGXtDv6vU0Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "google.cloud.artifactregistry"
    "google.cloud.artifactregistry_v1"
    "google.cloud.artifactregistry_v1beta2"
  ];

  meta = with lib; {
    description = "Google Cloud Artifact Registry API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-artifact-registry";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-artifact-registry-v${version}/packages/google-cloud-artifact-registry/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
