{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
, grpc-google-iam-v1
, mock
, libcst
, proto-plus
, protobuf
, pytestCheckHook
, pytest-asyncio
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-dataproc";
  version = "5.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+tfaWdOR/sFfGih71x1VznI3gZ2quQ4h1rEUCFHZ1DQ=";
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
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Test requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.dataproc"
    "google.cloud.dataproc_v1"
  ];

  meta = with lib; {
    description = "Google Cloud Dataproc API client library";
    homepage = "https://github.com/googleapis/python-dataproc";
    changelog = "https://github.com/googleapis/python-dataproc/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
