{ lib
, buildPythonPackage
, dateutil
, fetchFromGitHub
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
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-python";
    rev = "v${version}";
    sha256 = "1jfkf53jcf8lcq98qc0bw5d1d0yp3558mh8l2dqc9jlsm0smigjs";
  };

  propagatedBuildInputs = [
    requests
    dateutil
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

  patches = [
    (fetchpatch {
      url = "https://github.com/influxdata/influxdb-python/commit/cc41e290f690c4eb67f75c98fa9f027bdb6eb16b.patch";
      sha256 = "1fb9qrq1kp24pixjwvzhdy67z3h0wnj92aj0jw0a25fd0rdxdvg4";
    })
  ];

  disabledTests = [
    # Disable failing test
    "test_write_points_from_dataframe_with_tags_and_nan_json"
  ];

  pythonImportsCheck = [ "influxdb" ];

  meta = with lib; {
    description = "Python client for InfluxDB";
    homepage = "https://github.com/influxdb/influxdb-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
