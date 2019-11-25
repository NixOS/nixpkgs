{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71cd24a2b3eb335cb800c7159f423df1bd4dcd5171b234be15e3f31ec9f622da";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = https://github.com/prometheus/client_python;
    license = licenses.asl20;
  };
}
