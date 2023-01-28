{ lib
, buildPythonPackage
, fetchPypi
, google-api-core
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
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iuhXfFp6cfDNDtk3JS+U8YbQAOII0khY2bmvP75QAP4=";
  };

  propagatedBuildInputs = [
    google-api-core
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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
