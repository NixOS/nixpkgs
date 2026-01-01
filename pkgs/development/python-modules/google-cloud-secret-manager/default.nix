{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  grpc-google-iam-v1,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
<<<<<<< HEAD
  version = "2.26.0";
=======
  version = "2.25.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_secret_manager";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-DR1vdjJ2haDteKTPUPKJ4b+75WAm7Qr/qYZjuG1tUNY=";
=======
    hash = "sha256-o3krscswcyaQgpemFTYDGslIUsIiSPBK4RL/UahTtWE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.secretmanager"
    "google.cloud.secretmanager_v1"
    "google.cloud.secretmanager_v1beta1"
  ];

<<<<<<< HEAD
  meta = {
    description = "Secret Manager API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-secret-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-secret-manager-v${version}/packages/google-cloud-secret-manager/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siriobalmelli ];
=======
  meta = with lib; {
    description = "Secret Manager API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-secret-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-secret-manager-v${version}/packages/google-cloud-secret-manager/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
