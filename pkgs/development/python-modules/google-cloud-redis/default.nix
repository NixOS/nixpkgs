{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-redis";
  version = "2.15.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_redis";
    inherit version;
    hash = "sha256-0k3Ww3mznGAUQ4uQMAA+/5gTr71a8rj730cz3GXzZ2A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.redis"
    "google.cloud.redis_v1"
    "google.cloud.redis_v1beta1"
  ];

  meta = with lib; {
    description = "Google Cloud Memorystore for Redis API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-redis";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-redis-v${version}/packages/google-cloud-redis/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
