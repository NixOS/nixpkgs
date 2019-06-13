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
  version = "5.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hriag4d4gx4bsqisiz29478sj54b215p6xzmshlw6x9af4z5vxg";
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
