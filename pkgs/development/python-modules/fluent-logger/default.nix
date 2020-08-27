{ lib, buildPythonPackage, fetchPypi, msgpack }:

buildPythonPackage rec {
  pname = "fluent-logger";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7d47eae4d2a11c8cb0df10ae3d034d95b0b8cef9d060e59e7519ad1f82ffa73";
  };

  propagatedBuildInputs = [ msgpack ];

  # Tests fail because absent in package
  doCheck = false;

  meta = with lib; {
    description = "A structured logger for Fluentd (Python)";
    homepage = "https://github.com/fluent/fluent-logger-python";
    license = licenses.asl20;
  };
}
