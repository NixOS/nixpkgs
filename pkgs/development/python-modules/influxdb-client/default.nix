{ lib
, aiohttp
, aiocsv
, buildPythonPackage
, certifi
, ciso8601
, fetchFromGitHub
, numpy
, pandas
, python-dateutil
, pythonOlder
, reactivex
, setuptools
, urllib3
}:

buildPythonPackage rec {
  pname = "influxdb-client";
  version = "1.37.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-paS+/miraJ9vRL1ZEAWJRSVd1hGvrYJe+0YD/F4sGDs=";
  };

  propagatedBuildInputs = [
    certifi
    python-dateutil
    reactivex
    setuptools
    urllib3
  ];

  passthru.optional-dependencies = {
    async = [
      aiocsv
      aiohttp
    ];
    ciso = [
      ciso8601
    ];
    extra = [
      numpy
      pandas
    ];
  };

  # Requires influxdb server
  doCheck = false;

  pythonImportsCheck = [
    "influxdb_client"
  ];

  meta = with lib; {
    description = "InfluxDB client library";
    homepage = "https://github.com/influxdata/influxdb-client-python";
    changelog = "https://github.com/influxdata/influxdb-client-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
