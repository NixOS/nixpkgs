{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  grpc-google-iam-v1,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "google-cloud-iot";
  version = "2.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pLQgcwR89F+9jcSDtW/5+6Gy+Wk7XQf4iD49vDPkN9U=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # requires credentials
    "test_list_device_registries"
  ];

  pythonImportsCheck = [
    "google.cloud.iot"
    "google.cloud.iot_v1"
  ];

  meta = with lib; {
    description = "Cloud IoT API API client library";
    homepage = "https://github.com/googleapis/python-iot";
    changelog = "https://github.com/googleapis/python-iot/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
