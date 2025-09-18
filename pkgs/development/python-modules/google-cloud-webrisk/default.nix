{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-webrisk";
  version = "1.18.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_webrisk";
    inherit version;
    hash = "sha256-3OUxiDZtRfmipeyCW8in6+GkVnlilWgE8Hzr6G+1KQU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.webrisk"
    "google.cloud.webrisk_v1"
    "google.cloud.webrisk_v1beta1"
  ];

  meta = with lib; {
    description = "Python Client for Web Risk";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-webrisk";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-webrisk-v${version}/packages/google-cloud-webrisk/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
