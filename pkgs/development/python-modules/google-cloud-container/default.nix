{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, libcst
, mock
, proto-plus
, protobuf
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-container";
  version = "2.32.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aU+42neWNlPhxw+mCSi0oR+vjh8VgKOQJQU6PhvM5t4=";
  };

  propagatedBuildInputs = [
    google-api-core
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
    # Test requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.container"
    "google.cloud.container_v1"
    "google.cloud.container_v1beta1"
  ];

  meta = with lib; {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/googleapis/python-container";
    changelog = "https://github.com/googleapis/python-container/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
