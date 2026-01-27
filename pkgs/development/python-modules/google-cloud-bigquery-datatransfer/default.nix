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

buildPythonPackage rec {
  pname = "google-cloud-bigquery-datatransfer";
  version = "3.21.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_bigquery_datatransfer";
    inherit version;
    hash = "sha256-zVgZBASf80Iv4RPHFa9Oy7E8+/UqU+l63UH6nl6+SHA=";
  };

  build-system = [ setuptools ];

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
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-bigquery-datatransfer-v${version}/packages/google-cloud-bigquery-datatransfer/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
