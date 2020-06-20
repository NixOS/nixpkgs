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
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bcaafd57ac152b9824ab12ed19f204206ef5df8af68404770554c5b55b475f6";
  };

  # ImportError: No module named tests
  doCheck = false;
  propagatedBuildInputs = [ requests dateutil pytz six ];

  meta = with stdenv.lib; {
    description = "Python client for InfluxDB";
    homepage = "https://github.com/influxdb/influxdb-python";
    license = licenses.mit;
  };

}
