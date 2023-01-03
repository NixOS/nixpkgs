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
  version = "2.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-r/AmdcXIChEqp3AvO2xU2lsM3pqmn/Tmv8/cQJ+kuCE=";
  };

  propagatedBuildInputs = [
    google-api-core
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  checkInputs = [
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
