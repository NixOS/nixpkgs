{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9da7b32f02439d8c04f7777021c304ed51d9ec180604700c1ba72a4d44dceb03";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    license = licenses.asl20;
  };
}
