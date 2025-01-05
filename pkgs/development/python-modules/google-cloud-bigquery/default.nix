{
  lib,
  buildPythonPackage,
  db-dtypes,
  fetchPypi,
  freezegun,
  google-api-core,
  google-cloud-bigquery-storage,
  google-cloud-core,
  google-cloud-datacatalog,
  google-cloud-storage,
  google-cloud-testutils,
  google-resumable-media,
  grpcio,
  ipython,
  mock,
  pandas,
  proto-plus,
  protobuf,
  psutil,
  pyarrow,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  requests,
  setuptools,
  tqdm,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "3.27.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_bigquery";
    inherit version;
    hash = "sha256-N5xSQFTXsJD6VtDCJmLMbmRYpiKbZ1TA5xd+OnNCHSw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    grpcio
    google-api-core
    google-cloud-core
    google-cloud-bigquery-storage
    google-resumable-media
    proto-plus
    protobuf
    requests
    python-dateutil
  ] ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    bqstorage = [
      google-cloud-bigquery-storage
      grpcio
      pyarrow
    ];
    pandas = [
      db-dtypes
      pandas
      pyarrow
    ];
    tqdm = [ tqdm ];
    ipython = [ ipython ];
  };

  nativeCheckInputs =
    [
      freezegun
      google-cloud-testutils
      mock
      psutil
      google-cloud-datacatalog
      google-cloud-storage
      pytestCheckHook
      pytest-xdist
    ]
    ++ optional-dependencies.pandas
    ++ optional-dependencies.ipython;

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_bigquery_magic"
    "TestBigQuery"
    "test_context_with_no_query_cache_from_context"
    "test_arrow_extension_types_same_for_storage_and_REST_APIs_894"
    "test_list_rows_empty_table"
    "test_list_rows_page_size"
    "test_list_rows_range_csv"
    "test_list_rows_range"
    "test_list_rows_scalars_extreme"
    "test_list_rows_scalars"
    "test_dry_run"
    "test_session"
    # Mocking of _ensure_bqstorage_client fails
    "test_to_arrow_ensure_bqstorage_client_wo_bqstorage"
    # requires network
    "test_dbapi_create_view"
    "test_list_rows_nullable_scalars_dtypes"
    "test_parameterized_types_round_trip"
    "test_structs"
    "test_table_snapshots"
    "test__initiate_resumable_upload"
    "test__initiate_resumable_upload_mtls"
    "test__initiate_resumable_upload_with_retry"
    "test_table_clones"
    "test_context_with_default_connection"
    "test_context_with_custom_connection"
  ];

  disabledTestPaths = [
    # Tests require credentials
    "tests/system/test_query.py"
    "tests/system/test_job_retry.py"
    "tests/system/test_pandas.py"
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery"
    "google.cloud.bigquery_v2"
  ];

  meta = with lib; {
    description = "Google BigQuery API client library";
    homepage = "https://github.com/googleapis/python-bigquery";
    changelog = "https://github.com/googleapis/python-bigquery/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
