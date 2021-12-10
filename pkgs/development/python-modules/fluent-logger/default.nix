{ lib, buildPythonPackage, fetchFromGitHub, msgpack }:

buildPythonPackage rec {
  pname = "fluent-logger";
  version = "0.10.0";

  src = fetchFromGitHub {
     owner = "fluent";
     repo = "fluent-logger-python";
     rev = "v0.10.0";
     sha256 = "12pq5x3hqypr0dhx7x0xrlzx610ax4b5n1ispfcd2v041vlpz89m";
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
