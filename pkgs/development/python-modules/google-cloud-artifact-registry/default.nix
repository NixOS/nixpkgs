{ buildPythonPackage
, fetchPypi
, google-api-core
, google-auth
, grpc-google-iam-v1
, lib
, proto-plus
, protobuf
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-artifact-registry";
  version = "1.11.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5ASS7Lt6F7dWBhc82bW+0FBSDCePax2YF5hr+BAGabs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    google-auth
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
