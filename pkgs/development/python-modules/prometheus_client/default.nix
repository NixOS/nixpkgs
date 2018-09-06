{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17bc24c09431644f7c65d7bce9f4237252308070b6395d6d8e87767afe867e24";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = https://github.com/prometheus/client_python;
    license = licenses.asl20;
  };
}
