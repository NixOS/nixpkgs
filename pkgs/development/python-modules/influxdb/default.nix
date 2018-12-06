{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, dateutil
, pytz
, six
}:

buildPythonPackage rec {
  pname = "influxdb";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fqnshmsgifvp79pd4g9a1kyfxvpa9vczv0dv8x2jr2c5m1mi99v";
  };

  # ImportError: No module named tests
  doCheck = false;
  propagatedBuildInputs = [ requests dateutil pytz six ];

  meta = with stdenv.lib; {
    description = "Python client for InfluxDB";
    homepage = https://github.com/influxdb/influxdb-python;
    license = licenses.mit;
  };

}
