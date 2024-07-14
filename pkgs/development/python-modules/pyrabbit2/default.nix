{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pyrabbit2";
  version = "1.0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0nFgyzXAlvAHLfVzByM9AbEXpFEjbhNmBKjlG+bxBsA=";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "Pythonic interface to the RabbitMQ Management HTTP API";
    homepage = "https://github.com/deslum/pyrabbit2";
    license = licenses.mit;
    maintainers = [ ];
  };
}
