{ lib, buildPythonPackage, fetchPypi, msgpack }:

buildPythonPackage rec {
  pname = "fluent-logger";
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "678bda90c513ff0393964b64544ce41ef25669d2089ce6c3b63d9a18554b9bfa";
  };

  prePatch = ''
    substituteInPlace setup.py \
      --replace "msgpack<1.0.0" "msgpack"
  '';

  propagatedBuildInputs = [ msgpack ];

  # Tests fail because absent in package
  doCheck = false;
  pythonImportsCheck = [
    "fluent"
    "fluent.event"
    "fluent.handler"
    "fluent.sender"
  ];

  meta = with lib; {
    description = "A structured logger for Fluentd (Python)";
    homepage = "https://github.com/fluent/fluent-logger-python";
    license = licenses.asl20;
  };
}
