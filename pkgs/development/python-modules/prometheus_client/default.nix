{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "046cb4fffe75e55ff0e6dfd18e2ea16e54d86cc330f369bebcc683475c8b68a9";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = https://github.com/prometheus/client_python;
    license = licenses.asl20;
  };
}
