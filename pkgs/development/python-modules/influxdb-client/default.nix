{
  lib,
  aiohttp,
  aiocsv,
  buildPythonPackage,
  certifi,
  ciso8601,
  fetchFromGitHub,
  numpy,
  pandas,
  python-dateutil,
  reactivex,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "influxdb-client";
  version = "1.50.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb-client-python";
    tag = "v${version}";
    hash = "sha256-39ioVlTgvICHArTNhfXZQ+WrUda2B5LxLtMwXWp6krU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    python-dateutil
    reactivex
    urllib3
  ];

  optional-dependencies = {
    async = [
      aiocsv
      aiohttp
    ];
    ciso = [ ciso8601 ];
    extra = [
      numpy
      pandas
    ];
  };

  # Requires influxdb server
  doCheck = false;

  pythonImportsCheck = [ "influxdb_client" ];

  meta = {
    description = "InfluxDB client library";
    homepage = "https://github.com/influxdata/influxdb-client-python";
    changelog = "https://github.com/influxdata/influxdb-client-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
