{ lib, stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "prometheus_client";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r3510jq6iryd2a8jln2qpvqy112y5502ncbfkn116xl7gj74r6r";
  };

  doCheck = false;

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = https://github.com/prometheus/client_python;
    license = licenses.asl20;
  };
}
