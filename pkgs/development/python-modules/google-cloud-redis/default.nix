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
  version = "2.15.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vG8+mL1A5j9Cuwzmz+aYbjmYXWlGCzriDNtQoLbwmoU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
