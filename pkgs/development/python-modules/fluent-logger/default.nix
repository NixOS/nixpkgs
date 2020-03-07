{ lib, buildPythonPackage, fetchPypi, msgpack }:

buildPythonPackage rec {
  pname = "fluent-logger";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "814cb51892c620a00c5a6129fffaa09eeeb0c8822c9bcb4f96232ae3cbc4d8b3";
  };

  propagatedBuildInputs = [ msgpack ];
  
  # Tests fail because absent in package
  doCheck = false;

  meta = with lib; {
    description = "A structured logger for Fluentd (Python)";
    homepage = https://github.com/fluent/fluent-logger-python;
    license = licenses.asl20;
  };
}
