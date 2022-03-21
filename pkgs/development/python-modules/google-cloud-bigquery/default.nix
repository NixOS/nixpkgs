{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, freezegun
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
}:

buildPythonPackage rec {
  pname = "google-cloud-bigquery";
  version = "2.34.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DriC3zCgD1oe89M5ojpnAjCACyqySUWVkafmharWcU8=";
  };

  propagatedBuildInputs = [
    google-resumable-media
    google-cloud-core
    proto-plus
    pyarrow
  ];

  checkInputs = [
    freezegun
    google-cloud-testutils
    ipython
    mock
    pandas
    psutil
    google-cloud-datacatalog
    google-cloud-storage
    pytestCheckHook
  ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  disabledTests = [
    # requires credentials
    "test_bigquery_magic"
    "TestBigQuery"
    "test_arrow_extension_types_same_for_storage_and_REST_APIs_894"
    "test_query_retry_539"
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
