{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  google-api-core,
  google-cloud-bigquery-storage,
  google-cloud-core,
  google-resumable-media,
  grpcio,
  proto-plus,
  protobuf,
  python-dateutil,
  requests,

  # optional-dependencies
  pyarrow,
  db-dtypes,
  pandas,
  tqdm,
  ipython,

  #  tests
  freezegun,
  google-cloud-datacatalog,
  google-cloud-storage,
  google-cloud-testutils,
  mock,
  psutil,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "3.35.1";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_bigquery";
    inherit version;
    hash = "sha256-WZ8mys8ZCs/ogAD2zF9Lyea6rHiZ5PQGygVPGQb3GWA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-bigquery-storage
    google-cloud-core
    google-resumable-media
    grpcio
    proto-plus
    protobuf
    python-dateutil
    requests
  ]
  ++ google-api-core.optional-dependencies.grpc;

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

  nativeCheckInputs = [
    freezegun
    google-cloud-datacatalog
    google-cloud-storage
    google-cloud-testutils
    mock
    psutil
    pytest-xdist
    pytestCheckHook
  ]
  ++ optional-dependencies.pandas
  ++ optional-dependencies.ipython;

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "TestBigQuery"
    "test_arrow_extension_types_same_for_storage_and_REST_APIs_894"
    "test_bigquery_magic"
    "test_context_with_no_query_cache_from_context"
    "test_dry_run"
    "test_list_rows_empty_table"
    "test_list_rows_page_size"
    "test_list_rows_range"
    "test_list_rows_range_csv"
    "test_list_rows_scalars"
    "test_list_rows_scalars_extreme"
    "test_session"
    "test_to_arrow_query_with_empty_result"

    # Mocking of _ensure_bqstorage_client fails
    "test_to_arrow_ensure_bqstorage_client_wo_bqstorage"

    # requires network
    "test__initiate_resumable_upload"
    "test__initiate_resumable_upload_mtls"
    "test__initiate_resumable_upload_with_retry"
    "test_context_with_custom_connection"
    "test_context_with_default_connection"
    "test_dbapi_create_view"
    "test_list_rows_nullable_scalars_dtypes"
    "test_parameterized_types_round_trip"
    "test_structs"
    "test_table_clones"
    "test_table_snapshots"
  ];

  disabledTestPaths = [
    # Tests require credentials
    "tests/system/test_job_retry.py"
    "tests/system/test_pandas.py"
    "tests/system/test_query.py"

    # ModuleNotFoundError: No module named 'google.cloud.resourcemanager_v3'
    "tests/system/test_client.py"
  ];

  pythonImportsCheck = [
    "google.cloud.bigquery"
    "google.cloud.bigquery_v2"
  ];

  meta = {
    description = "Google BigQuery API client library";
    homepage = "https://github.com/googleapis/python-bigquery";
    changelog = "https://github.com/googleapis/python-bigquery/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
