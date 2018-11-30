{ lib, buildPythonPackage, fetchPypi, msgpack }:

buildPythonPackage rec {
  pname = "fluent-logger";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09vii0iclfq6vhz37xyybksq9m3538hkr7z40sz2dlpf2rkg98mg";
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
