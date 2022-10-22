{ lib
, buildPythonPackage
, python-dateutil
, fetchPypi
, fetchpatch
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

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ymjv322mv6y424fmpd70f87152w55mbwwj6i7p3sjzf0ixmxy26";
  };

  propagatedBuildInputs = [
    requests
    python-dateutil
    pytz
    six
    msgpack
  ];

  checkInputs = [
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
    # Reponse is not empty but `s = '孝'` and the JSON decoder chokes on that
    "test_query_with_empty_result"
  ];

  pythonImportsCheck = [ "influxdb" ];

  meta = with lib; {
    description = "Python client for InfluxDB";
    homepage = "https://github.com/influxdb/influxdb-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
