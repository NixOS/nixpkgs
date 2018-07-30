{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "69494dc1ac967c0f626c8193e439755c2b95dd4ed22ef31c277601778a50c7ff";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = https://github.com/prometheus/client_python;
    license = licenses.asl20;
  };
}
