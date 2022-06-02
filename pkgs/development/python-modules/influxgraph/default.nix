{ lib, buildPythonPackage, fetchPypi, isPy3k
, influxdb, graphite_api, python-memcached
}:

buildPythonPackage rec {
  pname = "influxgraph";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l33sfwdh4bfprmzp2kx0d9098g6yxbnhyyx9qr3kzczpm0jg9vy";
  };

  propagatedBuildInputs = [ influxdb graphite_api python-memcached ];

  passthru.moduleName = "influxgraph.InfluxDBFinder";

  meta = with lib; {
    description = "InfluxDB storage plugin for Graphite-API";
    homepage = "https://github.com/InfluxGraph/influxgraph";
    license = licenses.asl20;
    maintainers = with maintainers; [ basvandijk ];
  };
}
