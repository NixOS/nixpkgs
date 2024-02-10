{ lib
, buildPythonPackage
, python-dateutil
, fetchPypi
, mock
, msgpack
, nose
, pandas
, pytestCheckHook
, pytz
, requests
, requests-mock
, six
}:

buildPythonPackage rec {
  pname = "influxdb";
  version = "5.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ymjv322mv6y424fmpd70f87152w55mbwwj6i7p3sjzf0ixmxy26";
  };

  postPatch = ''
    for f in influxdb/tests/dataframe_client_test.py influxdb/tests/influxdb08/dataframe_client_test.py; do
      substituteInPlace "$f" \
        --replace "pandas.util.testing" "pandas.testing"
    done
  '';

  propagatedBuildInputs = [
    requests
    python-dateutil
    pytz
    six
    msgpack
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    mock
    nose
    pandas
  ];

  disabledTests = [
    # Tests cause FutureWarning due to use of 'record' instead of 'records' in pandas.
    #   https://github.com/influxdata/influxdb-python/pull/845
    # Also type mismatches in assertEqual on DataFrame:
    #   b'foo[30 chars]_one=1.0,column_two=1.0 0\nfoo,tag_one=red,tag[47 chars]00\n' !=
    #   b'foo[30 chars]_one="1",column_two=1i 0\nfoo,tag_one=red,tag_[46 chars]00\n'
    "test_write_points_from_dataframe_with_nan_json"
    "test_write_points_from_dataframe_with_tags_and_nan_json"
    "test_write_points_from_dataframe_with_numeric_precision"
    # Reponse is not empty but `s = '孝'` and the JSON decoder chokes on that
    "test_query_with_empty_result"
    # Pandas API changes cause it to no longer infer datetimes in the expected manner
    "test_multiquery_into_dataframe"
    "test_multiquery_into_dataframe_dropna"
  ];

  pythonImportsCheck = [ "influxdb" ];

  meta = with lib; {
    description = "Python client for InfluxDB";
    homepage = "https://github.com/influxdb/influxdb-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
