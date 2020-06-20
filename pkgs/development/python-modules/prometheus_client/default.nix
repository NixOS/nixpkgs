{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c6e6b706833a6bd1fd51711299edee907857be10ece535126a158f911ee80915";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    license = licenses.asl20;
  };
}
