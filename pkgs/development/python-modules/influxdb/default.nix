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
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0injsml6zmb3hkgc03117fdlg573kbfgjbijpd5npf0vsy0xnpvz";
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
