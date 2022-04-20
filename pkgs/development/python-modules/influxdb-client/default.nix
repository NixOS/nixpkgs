{ lib
, buildPythonPackage
, fetchFromGitHub
, rx
, certifi
, six
, python-dateutil
, setuptools
, urllib3
, ciso8601
, pytz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "influxdb-client";
  version = "1.28.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-+ofOJEOsQHYi6lYucvPCVztb8k/lFIveAu7NKMqOOew=";
  };

  propagatedBuildInputs = [
    rx
    certifi
    six
    python-dateutil
    setuptools
    urllib3
    ciso8601
    pytz
  ];

  # requires influxdb server
  doCheck = false;

  pythonImportsCheck = [
    "influxdb_client"
  ];

  meta = with lib; {
    description = "InfluxDB 2.0 Python client library";
    homepage = "https://github.com/influxdata/influxdb-client-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
