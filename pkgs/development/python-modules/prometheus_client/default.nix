{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8c11ff5ca53de6c3d91e1510500611cafd1d247a937ec6c588a0a7cc3bef93c";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = https://github.com/prometheus/client_python;
    license = licenses.asl20;
  };
}
