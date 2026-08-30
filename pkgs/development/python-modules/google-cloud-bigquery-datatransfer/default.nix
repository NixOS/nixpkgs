{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pytz,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.23.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_bigquery_datatransfer";
    inherit (finalAttrs) version;
    hash = "sha256-LQEAqT9uiaEV1mjU/Cq8DwwiPqCZ9bfHNrzgECumI/k=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    libcst
    proto-plus
    protobuf
    pytz
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery_datatransfer"
    "google.cloud.bigquery_datatransfer_v1"
  ];

  disabledTests = [
    # Tests require project ID
    "test_list_data_sources"
  ];

  meta = {
    description = "BigQuery Data Transfer API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-bigquery-datatransfer";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-bigquery-datatransfer-v${finalAttrs.version}/packages/google-cloud-bigquery-datatransfer/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
