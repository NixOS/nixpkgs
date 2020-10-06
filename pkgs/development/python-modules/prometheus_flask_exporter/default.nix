{ stdenv, buildPythonPackage, fetchPypi, flask, prometheus_client }:

buildPythonPackage rec {
  pname = "prometheus_flask_exporter";
  version = "0.15.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c590656b45fa6dd23d81dec3d3dc1e31b17fcba48310f69d0ff31b5c865fc799";
  };

  propagatedBuildInputs = [
    flask prometheus_client
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rycus86/prometheus_flask_exporter";
    description = "Prometheus exporter for Flask applications";
    maintainers = with maintainers; [ nphilou ];
    license = licenses.mit;
  };
}
