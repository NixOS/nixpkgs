{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, influxdb, graphite_api, memcached
}:

buildPythonPackage rec {
  pname = "influxgraph";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l33sfwdh4bfprmzp2kx0d9098g6yxbnhyyx9qr3kzczpm0jg9vy";
  };

  patchPhase = stdenv.lib.optionalString isPy3k ''
    sed 's/python-memcached/python3-memcached/' \
      -i ./influxgraph.egg-info/requires.txt    \
      -i ./setup.py
  '';

  propagatedBuildInputs = [ influxdb graphite_api memcached ];

  passthru.moduleName = "influxgraph.InfluxDBFinder";

  meta = with stdenv.lib; {
    description = "InfluxDB storage plugin for Graphite-API";
    homepage = https://github.com/InfluxGraph/influxgraph;
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
  };
}
