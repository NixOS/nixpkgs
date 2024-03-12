{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.18.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HbL0CTJFNuNPmFCB04njl0yjo2aN94RcrQvgOrjA+n0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.secretmanager"
    "google.cloud.secretmanager_v1"
    "google.cloud.secretmanager_v1beta1"
  ];

  meta = with lib; {
    description = "Secret Manager API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-secret-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-secret-manager-v${version}/packages/google-cloud-secret-manager/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
