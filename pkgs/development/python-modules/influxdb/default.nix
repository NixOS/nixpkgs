{ stdenv
, buildPythonPackage
, fetchPypi
, requests
, dateutil
, pytz
, six
, msgpack
, fetchpatch
}:

buildPythonPackage rec {
  pname = "influxdb";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bcaafd57ac152b9824ab12ed19f204206ef5df8af68404770554c5b55b475f6";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/influxdata/influxdb-python/commit/cc41e290f690c4eb67f75c98fa9f027bdb6eb16b.patch";
      sha256 = "1fb9qrq1kp24pixjwvzhdy67z3h0wnj92aj0jw0a25fd0rdxdvg4";
    })
  ];

  # ImportError: No module named tests
  doCheck = false;
  propagatedBuildInputs = [ requests dateutil pytz six msgpack ];

  meta = with stdenv.lib; {
    description = "Python client for InfluxDB";
    homepage = "https://github.com/influxdb/influxdb-python";
    license = licenses.mit;
  };

}
