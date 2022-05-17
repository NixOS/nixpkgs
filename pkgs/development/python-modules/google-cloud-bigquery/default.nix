{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, db-dtypes
, freezegun
, google-cloud-bigquery-storage
, google-cloud-core
, google-cloud-datacatalog
, google-cloud-storage
, google-cloud-testutils
, google-resumable-media
, ipython
, mock
, pandas
, proto-plus
, psutil
, pyarrow
, pytest-xdist
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "3.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0tbK940cEz5//ZsLfi198fmy9wPeN3SXuW2adM/o7AI=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pyarrow >= 3.0.0, < 8.0dev' 'pyarrow >= 3.0.0, < 9.0dev'
  '';

  propagatedBuildInputs = [
    google-cloud-core
    google-cloud-bigquery-storage
    google-resumable-media
    proto-plus
    pyarrow
  ];

  checkInputs = [
    db-dtypes
    freezegun
    google-cloud-testutils
    ipython
    mock
    pandas
    psutil
    google-cloud-datacatalog
    google-cloud-storage
    pytestCheckHook
    pytest-xdist
  ];

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
    "test_list_rows_scalars"
    "test_list_rows_scalars_extreme"
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
  ];

  disabledTestPaths = [
    # requires credentials
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
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
