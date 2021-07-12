{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a8baade6cb80bcfe43297e33e7623f3118d660d41387593758e2fb1ea173a86";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    license = licenses.asl20;
  };
}
