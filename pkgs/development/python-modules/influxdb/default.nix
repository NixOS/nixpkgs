{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  msgpack,
  pandas,
  pytestCheckHook,
  python-dateutil,
  pytz,
  requests,
  requests-mock,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "influxdb";
  version = "5.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WMZH9gQ3Et2G6a7hLrTM+7tUFUZ7yZEKSKqMdMEQiXA=";
  };

  patches = [
    # https://github.com/influxdata/influxdb-python/pull/835
    ./remove-nose.patch
  ];

  postPatch = ''
    for f in influxdb/tests/dataframe_client_test.py influxdb/tests/influxdb08/dataframe_client_test.py; do
      substituteInPlace "$f" \
        --replace-fail "pandas.util.testing" "pandas.testing"
    done

    for f in influxdb/tests/influxdb08/client_test.py influxdb/tests/client_test.py; do
      substituteInPlace "$f" \
        --replace-fail "assertRaisesRegexp" "assertRaisesRegex"
    done
  '';

  build-system = [ setuptools ];

  dependencies = [
    msgpack
    python-dateutil
    pytz
    requests
    six
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    mock
    pandas
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    "socket"
    # Tests cause FutureWarning due to use of 'record' instead of 'records' in pandas.
    #   https://github.com/influxdata/influxdb-python/pull/845
    # Also type mismatches in assertEqual on DataFrame:
    #   b'foo[30 chars]_one=1.0,column_two=1.0 0\nfoo,tag_one=red,tag[47 chars]00\n' !=
    #   b'foo[30 chars]_one="1",column_two=1i 0\nfoo,tag_one=red,tag_[46 chars]00\n'
    "test_write_points_from_dataframe_with_nan_json"
    "test_write_points_from_dataframe_with_tags_and_nan_json"
    "test_write_points_from_dataframe_with_numeric_precision"
    # Response is not empty but `s = '孝'` and the JSON decoder chokes on that
    "test_query_with_empty_result"
    # Pandas API changes cause it to no longer infer datetimes in the expected manner
    "test_multiquery_into_dataframe"
    "test_multiquery_into_dataframe_dropna"
    # FutureWarning: 'H' is deprecated and will be removed in a future version, please use 'h' instead.
    "test_write_points_from_dataframe_with_tag_escaped"
    # AssertionError: 2 != 1 : <class 'influxdb.tests.helper_test.TestSeriesHelper.testWarnBulkSizeNoEffect.<locals>.WarnBulkSizeNoEffect'> call should have generated one warning.
    "testWarnBulkSizeNoEffect"
    # Timestamp precision 10^9 vs 10^12
    "test_dataframe_write_points_with_whitespace_in_column_names"
    "test_dataframe_write_points_with_whitespace_measurement"
    "test_write_points_from_dataframe"
    "test_write_points_from_dataframe_with_leading_none_column"
    "test_write_points_from_dataframe_with_line_of_none"
    "test_write_points_from_dataframe_with_nan_line"
    "test_write_points_from_dataframe_with_none"
    "test_write_points_from_dataframe_with_numeric_column_names"
    "test_write_points_from_dataframe_with_period_index"
    "test_write_points_from_dataframe_with_tag_cols_and_defaults"
    "test_write_points_from_dataframe_with_tag_cols_and_global_tags"
    "test_write_points_from_dataframe_with_tag_columns"
    "test_write_points_from_dataframe_with_tags_and_nan_line"
    "test_write_points_from_dataframe_with_time_precision"
  ];

  pythonImportsCheck = [ "influxdb" ];

  meta = {
    description = "Python client for InfluxDB";
    homepage = "https://github.com/influxdb/influxdb-python";
    changelog = "https://github.com/influxdata/influxdb-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
