{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-tasks";
  version = "2.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PvsoDnpjX1eGCgajRhMcEXBC6CCtSDr9JWgA+uG01wE=";
  };

  propagatedBuildInputs = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires credentials
    "test_list_queues"
  ];

  pythonImportsCheck = [
    "google.cloud.tasks"
    "google.cloud.tasks_v2"
    "google.cloud.tasks_v2beta2"
    "google.cloud.tasks_v2beta3"
  ];

  meta = with lib; {
    description = "Cloud Tasks API API client library";
    homepage = "https://github.com/googleapis/python-tasks";
    changelog = "https://github.com/googleapis/python-tasks/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
