{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-redis";
  version = "2.13.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XEhXMDVdlnI9ZK5jfxsiZPNbV8MB7A7yxtMLLwbcoU4=";
  };

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
    homepage = "https://github.com/googleapis/python-redis";
    changelog = "https://github.com/googleapis/python-redis/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
